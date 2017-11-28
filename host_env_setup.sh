#!/bin/bash

#install required packages

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y --no-install-recommends\
    apt-utils \
    software-properties-common \
    python-software-properties \
    git \
    kvm \
    qemu-kvm \
    libvirt-bin \
    bridge-utils \
    libguestfs-tools \
    make \
    wget \
    gcc \
    g++

add-apt-repository -y ppa:gophers/archive
apt-get update && apt-get install -y --no-install-recommends golang-1.9-go

export DEBIAN_FRONTENT=teletype
echo "Host environment setup completed."
