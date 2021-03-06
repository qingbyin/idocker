# use ubuntu
FROM ubuntu:20.04

# Work in the tmp directory
WORKDIR /tmp

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
RUN pip3 install cmake && \
    # Some packages need pkg-confg (e.g. PETSc)
    apt-get install -y pkg-config
# cpp
# latest g++
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-10 g++-10
ENV CXX=/usr/bin/g++-10 \
    CC=/usr/bin/gcc-10
RUN apt-get install ninja-build
# -----------------------------------------------------------------------------
# libs
# -----------------------------------------------------------------------------
# numba
RUN pip3 install --no-cache-dir numba
# pytest
RUN pip3 install pytest
# numpy (by default numpy fetches binary build including libblas. 
# PETSc is built with libopenblas from Ubuntu package. This can lead to conflict.
# So disable numpy fetching binary and use the Ubuntu package)
RUN apt-get install -y libopenblas-dev &&\
    pip3 install --no-binary="numpy" numpy --upgrade
# boost
RUN apt-get install -y libboost-dev
# mpi
RUN apt-get install -y libmpich-dev mpich &&\
    pip3 install --no-cache-dir mpi4py
# HDF5 for mpich
RUN apt install -y libhdf5-mpich-dev
# latest eigen3 (require blas)
RUN git clone https://gitlab.com/libeigen/eigen.git ~/eigen && \
    cd ~/eigen && mkdir build && cd build && \
    cmake .. && \
    make install && \
    cd ~ && \
    rm -rf ~/eigen
# Install basix (require Eigen3)
RUN git clone https://github.com/FEniCS/basix.git --branch main --single-branch &&\
    cmake -G Ninja -DCMAKE_BUILD_TYPE=Developer -B build-dir -S ./basix &&\
    cmake --build build-dir --parallel 3 &&\
    cmake --install build-dir &&\
    pip3 install ./basix/python
# Install ufl, ffcx
RUN pip3 install git+https://github.com/FEniCS/ufl.git --upgrade  && \
    pip3 install git+https://github.com/FEniCS/ffcx.git --upgrade
# PETSc (needs mpi and openblas)
ENV PETSC_DIR=$HOME/petsc
ENV PETSC_ARCH=linux-gnu-real-64
# needed by PTScotch
RUN apt-get install -y bison flex
RUN git clone -b release https://gitlab.com/petsc/petsc.git ${PETSC_DIR} && \
    cd ${PETSC_DIR} && \
    ./configure \
    PETSC_ARCH=linux-gnu-real-64 \
    --with-64-bit-indices=yes \
    --with-fortran-bindings=no \
    --with-shared-libraries \
    # PTScotch lib
    --download-ptscotch && \
    # Compile
    make PETSC_ARCH=linux-gnu-real-64 all && \
    # Clean
    rm -rf \
    ./**/tests/ \
    ./**/obj/ \
    ./**/externalpackages/  \
    ./CTAGS \
    ./RDict.log \
    ./TAGS \
    ./docs/ \
    ./share/ \
    ./src/ \
    ./systems/
# doc
RUN apt-get install -y doxygen && \
    pip3 install -U sphinx && \
    pip3 install sphinx_rtd_theme && \
    pip3 install breathe
# reduce the image space
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# use suer root (sudo) in the container
USER root
