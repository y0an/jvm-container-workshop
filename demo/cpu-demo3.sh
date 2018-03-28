#!/bin/bash

echo "docker run --cpu-period=100000 --cpu-quota=500000 ..."
echo
echo "Java 8"
docker run --cpu-period=100000 --cpu-quota=500000 toolbox.jdk8 CpuTest

echo
echo "Java 9"
docker run --cpu-period=100000 --cpu-quota=500000 toolbox.jdk9 CpuTest

echo
echo "Java 10"
docker run --cpu-period=100000 --cpu-quota=500000 toolbox.jdk10 CpuTest