#!/bin/bash

echo "docker run --cpuset-cpus=0 ..."
echo
echo "Java 8"
docker run --cpuset-cpus=0 toolbox.jdk8 CpuTest

echo
echo "Java 9"
docker run --cpuset-cpus=0 toolbox.jdk9 CpuTest

echo
echo "Java 10"
docker run --cpuset-cpus=0 toolbox.jdk10 CpuTest