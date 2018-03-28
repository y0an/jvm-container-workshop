#!/bin/bash

docker container rm -f simple-springboot 2>/dev/null

echo "docker run -d --name=simple-springboot -m 256MB --memory-swap=256MB simple-springboot-jdk8"

read -n1 -r -p "Press any key to continue..." key

container_id=$(docker run -d --name=simple-springboot -m 256MB --memory-swap=256MB simple-springboot-jdk8)

watch -n1 cat /sys/fs/cgroup/memory/docker/${container_id}/memory.usage_in_bytes /sys/fs/cgroup/memory/docker/${container_id}/memory.memsw.usage_in_bytes  

echo "Reading OOM Status in 'docker container inspect'"

echo "docker container inspect $(docker container ls -lq) --format={{.State.OOMKilled}}"

docker container inspect $(docker container ls -lq) --format={{.State.OOMKilled}}
