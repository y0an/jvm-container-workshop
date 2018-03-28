#!/bin/bash

echo "docker run openjdk:8-jre java -XshowSettings:vm -version"

docker run openjdk:8-jre java -XshowSettings:vm -version
