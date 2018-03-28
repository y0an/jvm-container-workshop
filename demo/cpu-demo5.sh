#!/bin/bash

echo 'docker run --cpus=1 openjdk:8-jre java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"'
echo
echo "##### Java 8"
docker run --cpus=1 openjdk:8-jre java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"

echo "##### Java 9"
docker run --cpus=1 openjdk:9-jre java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"

echo "##### Java 10"
docker run --cpus=1 openjdk:10-jre java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "MaxRam|MaxHeapSize|ParallelGCThreads|CICompilerCount|UseSerialGC|UseParallelGC|tenuring|UseG1GC|UseConcMarkSweepGC"
