# use ubuntu
FROM ubuntu:bionic
RUN apt-get update
# get add-apt-repository command
RUN apt-get install -y software-properties-common
# necessary for CircleCI
RUN apt-get install -y git && \
    apt-get install -y ssh && \
    apt-get install tar && \
    apt-get install gzip && \
    apt-get install ca-certificates
# install pip
RUN apt-get install -y python3-pip && \
    # update pip
    pip3 install --upgrade pip
# install latest cmake
RUN pip3 install cmake
# cpp
# latest g++
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-10 && \
    ln -sf /usr/bin/g++-10 /usr/bin/g++
RUN apt-get install ninja-build
# libs
# latest eigen3
RUN git clone https://gitlab.com/libeigen/eigen.git ~/eigen && \
    cd ~/eigen && mkdir build && cd build && \
    cmake .. && \
    make install && \
    cd ~ && \
    rm -rf ~/eigen
# latest boost
RUN add-apt-repository ppa:mhier/libboost-latest && \
    apt update && \
    apt-get install -y libboost1.74-dev
# mpi
RUN apt-get install -y \
    libmpich-dev \
    mpich
# doc
RUN apt-get install -y doxygen && \
    pip3 install -U sphinx && \
    pip3 install sphinx_rtd_theme && \
    pip3 install breathe
# reduce the image space
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# use suer root (sudo) in the container
USER root
