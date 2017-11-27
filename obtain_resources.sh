#!/bin/bash

#clone syzkaller and build binaries

mkdir /root/go
export GOPATH="/root/go"
export PATH="${PATH}:/usr/lib/go-1.9/bin"
export REPO_PATH="github.com/ScottieY/syzkaller"

go get -u -d $REPO_PATH/...
cd ~ && ln -s $GOPATH/src/$REPO_PATH syzkaller
cd ~/syzkaller && make manager fuzzer execprog TARGETOS=freebsd
mkdir -p /root/workdir
mkdir -p /root/.ssh

echo "Syzkaller built."
