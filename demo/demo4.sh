#!/bin/bash

echo "docker run openjdk:8-jre java -Xmx128m -XshowSettings:vm -version"

docker run openjdk:8-jre java -Xmx128m -XshowSettings:vm -version
