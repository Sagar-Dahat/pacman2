#!/bin/bash

docker rm -f $(docker ps -aq)
for pid in $( netstat -tunlp | grep -i ":80 " | awk '{ print $7 }' | cut -f 1 -d '/'); do echo $pid; kill -9 $pid; done