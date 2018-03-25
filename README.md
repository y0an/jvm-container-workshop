# JVM and container

## Memory

### Basics

Let's run a simple java 

```bash 
java -XshowSettings:vm -version 
```

```bash 
VM settings:
    Max. Heap Size (Estimated): 3.45G
    Ergonomics Machine Class: server
    Using VM: Java HotSpot(TM) 64-Bit Server VM

java version "1.8.0_162"
Java(TM) SE Runtime Environment (build 1.8.0_162-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.162-b12, mixed mode
```

And now let's run the same thing in a container:

```bash 
docker run openjdk:8-jre java -XshowSettings:vm -version
```
Nothing really change in the container :)

```bash 
VM settings:
    Max. Heap Size (Estimated): 3.45G
    Ergonomics Machine Class: server
    Using VM: OpenJDK 64-Bit Server VM

openjdk version "1.8.0_162"
OpenJDK Runtime Environment (build 1.8.0_162-8u162-b12-1~deb9u1-b12)
OpenJDK 64-Bit Server VM (build 25.162-b12, mixed mode)
```

Now we going to try to limit the memory of the JVM

```bash 
docker run -m 128MB openjdk:8-jre java -XshowSettings:vm -version
```
Ok again we have the same result, hum...

```bash 
VM settings:
    Max. Heap Size (Estimated): 3.45G
    Ergonomics Machine Class: server
    Using VM: OpenJDK 64-Bit Server VM

openjdk version "1.8.0_162"
OpenJDK Runtime Environment (build 1.8.0_162-8u162-b12-1~deb9u1-b12)
OpenJDK 64-Bit Server VM (build 25.162-b12, mixed mode
```

Why the JVM see those 3.45G? 
This is the Ergonomics :
https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html

We can read :

    A class of machine referred to as a server-class machine has been defined as a machine with the following:
        2 or more physical processors
        2 or more GB of physical memory

    On server-class machines, the following are selected by default:
        Throughput garbage collector
        Initial heap size of 1/64 of physical memory up to 1 GB
        Maximum heap size of 1/4 of physical memory up to 1 GB

### Try to change the HEAP

```bash 
docker run openjdk:8-jre java -Xmx128m -XshowSettings:vm -version
```
This looks better, the jvm set the max size to the value

```bash 
VM settings:
    Max. Heap Size: 128.00M
    Ergonomics Machine Class: server
...
```

But it's not really easy to build/ or configure Xmx when you deploy your application to k8s/Swarm/Mesos...



### JDK 8 1.8.0_131+ & JDK 9

The JDK 9 include an option to include a partial support of cgroups, it must be activate with UnlockExperimentalVMOptions / UseCGroupMemoryLimitForHeap. Those are backported to the JDK 8 1.8.0_131+

```bash 
docker run -m 128MB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version
```
This looks better, the jvm set the max size to the value

```bash 
VM settings:
    Max. Heap Size (Estimated): 57.00M
...
```

With more memory:

```bash 
docker run -m 1GB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version
```

```bash 
docker run -m 1GB openjdk:10-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version
```

Only 228MB are used :

```bash 
VM settings:
    Max. Heap Size (Estimated): 228.00M
...
```

You can tell the JVM to use more memory for HEAP with -XX:MaxRAMFraction (default is 4):
```bash 
docker run -m 1GB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -XshowSettings:vm -version
```

The JVM use available memory/MaxRAMFraction as max heap. Using -XX:MaxRAMFraction=1 we are using almost all the available memory as max heap.

## Swap

```bash
docker run -d simple-springboot-jdk8
```

```bash
docker stats
```
```bash
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %
137a549714d4        focused_bose        0.00%               44.2MiB / 15.52GiB    0.28%
24d624be19f2        optimistic_curie    0.17%               420.4MiB / 15.52GiB   2.65%
```

```bash
docker run -d -m 256MB simple-springboot-jdk8
```

```bash
docker stats
```
Swap!!!

```bash
docker run -d -m 256MB simple-springboot-jdk8 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -jar app.jar
```

No swap!!


### OOM Killer

Who is this bad guy?

Oom killer will kill the process who consume too much resource. 

It can be seeing in action :
```bash
journalctl -f _TRANSPORT=kernel
```

And then run
```bash
docker run -m 50MB  jvmtest HeapTest
```

You should read something like:
```logs
 kernel: Memory cgroup out of memory: Kill process 20184 (java) score 1119 or sacrifice child
```

And you can also check the state of the previous container and search the OOMKilled field.
```bash
docker container inspect $(docker container ls -lq) 
```

or directly:
```bash
docker container inspect $(docker container ls -lq) --format={{.State.OOMKilled}}
```

## CPU

In docker you can reduce the cpu use of container by:
* --cpus=
* --cpuset-cpus=
* --cpuset-shares=
* --cpu-period & --cpu-quota

```bash
docker run --cpuset-cpus=0  toolbox.jdk9 CpuLoadTest
```

All Java 8,9 & 10 will be limited in cpu use with Cgroups, but the JVM is not aware of this.
So the JVM isn't optimize for the available cpu (container) but for the number of cpu in the host.


### --cpus

```bash
docker run --cpus=1 toolbox.jdk8 CpuTest
docker run --cpus=1 toolbox.jdk9 CpuTest
docker run --cpus=1 toolbox.jdk10 CpuTest
```
It failed for JDK8 & 9.

### --cpuset-cpus

```bash
docker run --cpuset-cpus=0 toolbox.jdk8 CpuTest
docker run --cpuset-cpus=0 toolbox.jdk9 CpuTest
docker run --cpuset-cpus=0 toolbox.jdk10 CpuTest
```
It works on JDK8 & 9 & 10!

### --cpu-shares

```bash
docker run --cpu-shares=1024 toolbox.jdk8 CpuTest
docker run --cpu-shares=1024 toolbox.jdk9 CpuTest
docker run --cpu-shares=1024 toolbox.jdk10 CpuTest
```
Failed for all, but it's not 

### --cpu-period & --cpu-quota

```bash
docker run --cpu-period=100000 --cpu-quota=500000 toolbox.jdk8 CpuTest
docker run --cpu-period=100000 --cpu-quota=500000 toolbox.jdk9 CpuTest
docker run --cpu-period=100000 --cpu-quota=500000 toolbox.jdk10 CpuTest
```

Once again failed for JDK8 & 9.


### Impact on JVM configuration

```bash
docker run --cpus=1 openjdk:8-jre java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"
```

```
intx CICompilerCount                          := 4                                   {product}
uintx ParallelGCThreads                         = 8                                   {product}
bool UseConcMarkSweepGC                        = false                               {product}
bool UseG1GC                                   = false                               {product}
bool UseParallelGC                            := true                                {product}
bool UseSerialGC                               = false                               {product}
```



## JDK 10

What does the brand new JDK10?

```bash
docker run -m 128MB openjdk:10-jre java -XshowSettings:vm -version
```

Looks Like it's work!!!

```bash
VM settings:
    Max. Heap Size (Estimated): 61.88M
    Using VM: OpenJDK 64-Bit Server VM

openjdk version "10" 2018-03-20
OpenJDK Runtime Environment (build 10+46-Debian-2)
OpenJDK 64-Bit Server VM (build 10+46-Debian-2, mixed mode)
```

More information

```bash
docker run openjdk:10-jre java -XshowSettings:vm  -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"
```

```
     intx CICompilerCount                          = 4                                        {product} {ergonomic}
     bool CICompilerCountPerCPU                    = true                                     {product} {default}
    uintx InitialTenuringThreshold                 = 7                                        {product} {default}
   size_t MaxHeapSize                              = 4167041024                               {product} {ergonomic}
 uint64_t MaxRAM                                   = 137438953472                          {pd product} {default}
    uintx MaxRAMFraction                           = 4                                        {product} {default}
   double MaxRAMPercentage                         = 25.000000                                {product} {default}
    uintx MaxTenuringThreshold                     = 15                                       {product} {default}
     uint ParallelGCThreads                        = 8                                        {product} {default}
     bool UseConcMarkSweepGC                       = false                                    {product} {default}
     bool UseG1GC                                  = true                                     {product} {ergonomic}
     bool UseParallelGC                            = false                                    {product} {default}
     bool UseSerialGC                              = false                                    {product} {default}
VM settings:
    Max. Heap Size (Estimated): 3.88G
    Using VM: OpenJDK 64-Bit Server VM

openjdk version "10" 2018-03-20
OpenJDK Runtime Environment (build 10+46-Debian-2)
OpenJDK 64-Bit Server VM (build 10+46-Debian-2, mixed mode)
``̀

And if we limit the memory to 128MB :
```bash
docker run -m 128MB openjdk:10-jre java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"
```

```bash
     intx CICompilerCount                          = 4                                        {product} {ergonomic}
     bool CICompilerCountPerCPU                    = true                                     {product} {default}
    uintx InitialTenuringThreshold                 = 7                                        {product} {default}
   size_t MaxHeapSize                              = 67108864                                 {product} {ergonomic}
 uint64_t MaxRAM                                   = 137438953472                          {pd product} {default}
    uintx MaxRAMFraction                           = 4                                        {product} {default}
   double MaxRAMPercentage                         = 25.000000                                {product} {default}
    uintx MaxTenuringThreshold                     = 15                                       {product} {default}
     uint ParallelGCThreads                        = 0                                        {product} {default}
     bool UseConcMarkSweepGC                       = false                                    {product} {default}
     bool UseG1GC                                  = false                                    {product} {default}
     bool UseParallelGC                            = false                                    {product} {default}
     bool UseSerialGC                              = true                                     {product} {ergonomic}
VM settings:
    Max. Heap Size (Estimated): 61.88M
    Using VM: OpenJDK 64-Bit Server VM

openjdk version "10" 2018-03-20
OpenJDK Runtime Environment (build 10+46-Debian-2)
OpenJDK 64-Bit Server VM (build 10+46-Debian-2, mixed mode)
```







Check the GC configuration, and the thread numbers for CICompiler, GC Threads

 y0an@orion   docker run  --memory 128MB heapeater -Xmx128m -jar app.jar

 y0an@orion   docker run  --memory 128MB --memory-swap 128MB heapeater -jar app.jar
 


watch swap:

```bash
watch -n1 cat /sys/fs/cgroup/memory/docker/9c86bb6e2da634b8de299ce87da7d4ff8cda0b2c4f5d9edf1c44f75224aeb58a/memory.stat 
```



## OOM Killer

Who is this bad guy?

Oom killer will kill the process who consume too much resource. 

It can be seeing in action :
```bash
journalctl -f _TRANSPORT=kernel
```

And then run
```bash
docker run -m 50MB  jvmtest HeapTest
```

You should read something like:
```logs
 kernel: Memory cgroup out of memory: Kill process 20184 (java) score 1119 or sacrifice child
```

And you can also check the state of the previous container and search the OOMKilled field.
```bash
docker container inspect $(docker container ls -lq) 
```

or directly:
```bash
docker container inspect $(docker container ls -lq) --format={{.State.OOMKilled}}
```

## Jstatd


Inliner

```bash
jstatd -p 1099 -J-Djava.security.policy=<(echo 'grant codebase "file:${java.home}/../lib/tools.jar" {permission java.security.AllPermission;};')
``̀
Mesurer la swap container
Mesurer la conso jvm global




https://docs.docker.com/config/containers/resource_constraints/#--memory-swap-details



docker run -m 100MB --memory-swap=100MB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm
-version


## More

Curious about JVM and options? Check this:
```bash
java -XX:+AggressiveOpts -XX:+UnlockDiagnosticVMOptions -XX:+UnlockExperimentalVMOptions -XX:+PrintFlagsFinal -version | wc -l
```



 -XX:+PrintFlagsFinal 
  -XX:+PrintGCDetails



docker run openjdk:8-jre java -XshowSettings:vm  -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"


## Real App tests

Let's start a simple Spring Boot Project

```bash
docker run  simple-springboot -jar app.jar
```

And check the memory size

```bash
docker stats 
```

```bash
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT  
942291a20d4f        silly_colden        0.13%               365.6MiB / 15.52GiB
```

```bash
docker run -m 365MB simple-springboot -Xmx365m  -jar app.jar
```


```bash
docker run -m 160MB simple-springboot -Xmx160m  -jar app.jar
```