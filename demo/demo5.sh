#!/bin/bash

echo "docker run -m 128MB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version"

docker run -m 128MB openjdk:8-jre java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XshowSettings:vm -version
