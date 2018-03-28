#!/bin/bash

echo "docker run --cpus=1 ..."
echo
echo "Java 8"
docker run --cpus=1 toolbox.jdk8 CpuTest

echo
echo "Java 9"
docker run --cpus=1 toolbox.jdk9 CpuTest

echo
echo "Java 10"
docker run --cpus=1 toolbox.jdk10 CpuTest