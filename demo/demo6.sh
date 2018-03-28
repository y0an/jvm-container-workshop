#!/bin/bash

echo "docker run -m 1GB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version"

docker run -m 1GB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version
