#!/bin/sh
test "$1" = "-x" && {
  echo "Enable experimental vm options"
  export JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -XX:+UseG1GC"
}
java $JAVA_OPTS Heap