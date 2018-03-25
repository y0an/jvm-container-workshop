#!/bin/sh


docker build -f Dockerfile.jdk7 -t toolbox.jdk7 .
docker build -f Dockerfile.jdk8 -t toolbox.jdk8 .
docker build -f Dockerfile.jdk9 -t toolbox.jdk9 .
docker build -f Dockerfile.jdk10 -t toolbox.jdk10 .
docker build -f Dockerfile.fabric8 -t toolbox.fabric8 .