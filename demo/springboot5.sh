#!/bin/bash

docker container rm -f simple-springboot 2>/dev/null

echo "NO CPU LIMIT"

echo "docker run -d --rm --name=simple-springboot simple-springboot-jdk8 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar app.jar"

read -n1 -r -p "Press any key to continue..." key

container_id=$(docker run -d --rm --name=simple-springboot simple-springboot-jdk8 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar app.jar)

echo $(pgrep -f java)
watch -n1 "cat /proc/$(pgrep -f java)/status | grep Threads"
