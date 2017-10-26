#########################################################################
# File Name: build.sh
# Author: Robin Luo
# Mail: xjluogang@hotmail.com
# Created Time: Thu 23 Jun 2016 03:18:40 AM UTC
#########################################################################
#!/bin/bash

docker build -f Dockerfile-java8 -t neofreko/java8 . && \
docker build -f Dockerfile-java8-android -t neofreko/java8-android . && \
docker build -f Dockerfile-java8-android-node -t neofreko/java8-android-node . && \
docker build -f Dockerfile-java8-android-node-appium -t neofreko/java8-android-node-appium .