#!/bin/sh
env ASSUME_ALWAYS_YES=YES pkg bootstrap
env ASSUME_ALWAYS_YES=YES pkg install git gcc

git clone https://github.com/ScottieY/syzkaller ~/syzkaller

cd ~/syzkaller && gcc executor/executor_freebsd.cc -o syz-executor -O1 -lpthread -DGOOS=\"freebsd\" -DGIT_REVISION=\"$(git rev-parse HEAD)\"
cp ~/syzkaller/syz-executor ~/
