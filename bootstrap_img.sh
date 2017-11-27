#!/bin/bash
env ASSUME_ALWAYS_YES=YES pkg bootstrap
env ASSUME_ALWAYS_YES=YES pkg install git

cd ~ && git clone https://github.com/ScottieY/syzkaller

GITREV=$(git rev-parse HEAD)
[ "$(git diff --shortstat)" == "" ] && REV=$GITREV || REV=$GITREV+

cd ~/syzkaller && c++ executor/executor_freebsd.cc -o syz-executor -O1 -lpthread -DGOOS=\"freebsd\" -DGIT_REVISION=\"$(git rev-parse HEAD)\"
cp ~/syzkaller/syz-executor ~/
