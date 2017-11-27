#!/bin/bash

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
    wget

add-apt-repository -y ppa:gophers/archive
apt-get update && apt-get install -y --no-install-recommends golang-1.9-go
mkdir /root/go

export GOPATH="/root/go"
export PATH="${PATH}:/usr/lib/go-1.9/bin"

export REPO_PATH="github.com/ScottieY/syzkaller"

go get -u -d $REPO_PATH/...
cd ~ && ln -s $GOPATH/src/$REPO_PATH syzkaller
cd ~/syzkaller && make manager fuzzer execprog TARGETOS=freebsd
mkdir -p /root/workdir
mkdir -p /root/.ssh


#if [ ! -e /dev/kvm ]; then
#  mknod /dev/kvm c 10 $(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ')
#fi

export DEBIAN_FRONTENT=teletype

#get image from master machine
# scp FreeBSD-12.0-CURRENT-amd64.qcow2 master:~/

#qemu-system-x86_64 -m 2048 -hda FreeBSD-12.0-CURRENT-amd64.qcow2 -enable-kvm -netdev user,id=mynet0,host=10.0.2.10,hostfwd=tcp::10022-:22 -device e1000,netdev=mynet0 -nographic
