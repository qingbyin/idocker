# use ubuntu
FROM ubuntu:bionic
RUN apt-get update
# necessary for CircleCI
RUN apt-get install -y git && \
    apt-get install -y ssh && \
    apt-get install tar && \
    apt-get install gzip && \
    apt-get install ca-certificates
# cpp
RUN apt-get install -y gcc g++ && \
    apt-get install ninja-build
# libs
RUN apt-get install libeigen3-dev
# install pip
RUN apt-get install -y python3-pip && \
    # update pip
    pip3 install --upgrade pip
# install latest cmake
RUN pip3 install cmake
# doc
RUN apt-get install -y doxygen && \
    pip3 install -U sphinx && \
    pip3 install sphinx_rtd_theme && \
    pip3 install breathe
# reduce the image space
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# use suer root (sudo) in the container
USER root
