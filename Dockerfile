FROM ubuntu:bionic
RUN apt-get update && \
    # necessary for CircleCI
    apt-get install git && \
    apt-get install ssh && \
    apt-get install tar && \
    apt-get install gzip && \
    apt-get install ca-certificates && \
    apt-get install -y python3-pip  && \
    # update pip
    pip3 install --upgrade pip && \
    # install latest cmake
    pip3 install cmake && \
    # reduce the image space
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# use suer root (sudo) in the container
USER root
