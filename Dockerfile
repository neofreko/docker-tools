FROM ubuntu:16.04

###########################################
# Install openjdk 8 and basic components
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk git curl wget zip unzip gawk python perl ruby net-tools make sudo build-essential && \
    apt-get install -y ant maven gradle && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -x && \
    useradd -m -s /bin/bash build && \
    echo "build:build" | chpasswd && \
    adduser build sudo && \
    chown build /opt

# Setup environment
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH ${PATH}:${JAVA_HOME}/bin

# Check command
RUN which java
RUN which javac

# Build command
# docker build -f Dockerfile-java8 -t robinluo/java8 .

###########################################
# Install android SDK
# No need lib32 after android platform-tools 24.+
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    wget --progress=dot:giga -O /opt/android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar xzf /opt/android-sdk.tgz -C /opt && \
    rm -rf /opt/android-sdk.tgz && \
    echo y | /opt/android-sdk-linux/tools/android update sdk --all --filter platform-tools,tools,build-tools-24.0.1 --no-ui --force && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/android-sdk-linux/temp/*

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/24.0.1

# Check command
RUN which adb
RUN which aapt
RUN which android

# Expose default ADB port
EXPOSE 5037

# Start adb server by default
CMD adb -a -P 5037 server nodaemon

# Build command
# docker build -f Dockerfile-java8-android -t robinluo/java8-android .

###########################################
# Switch over to the build user.
USER build

# Set node installation home
ENV N_PREFIX /opt/n
ENV PATH ${PATH}:${N_PREFIX}/bin

# Install n, node, npm
RUN set -x && \
    curl -L https://git.io/n-install | bash -s -- -y latest && \
    n lts && n latest

# Switch back to root
USER root

# Check command
RUN which node
RUN which npm

# Build command
# docker build -f Dockerfile-java8-android-node -t robinluo/java8-android-node .

###########################################
# Switch over to the build user.
USER build

# Install appium
RUN set -x && \
    npm --loglevel http \
    install -g gulp appium appium-doctor grunt grunt-cli mocha

RUN which appium
RUN which appium-doctor
RUN which gulp

# Switch back to root
USER root

# Build command
# docker build -f Dockerfile-java8-android-node-appium -t robinluo/java8-android-node-appium .

###########################################
# T.B.D