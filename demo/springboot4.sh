#!/bin/bash

docker container rm -f simple-springboot 2>/dev/null

echo "docker run -d --rm --name=simple-springboot -m 256MB simple-springboot-jdk8 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar app.jar"

read -n1 -r -p "Press any key to continue..." key

container_id=$(docker run -d --rm --name=simple-springboot -m 256MB simple-springboot-jdk8 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar app.jar)

#docker stats simple-springboot

watch -n2 cat /sys/fs/cgroup/memory/docker/${container_id}/memory.usage_in_bytes /sys/fs/cgroup/memory/docker/${container_id}/memory.memsw.usage_in_bytes  
