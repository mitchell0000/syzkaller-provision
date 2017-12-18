#!/bin/bash
if [[ ! $1 ]];then
  echo "Missing docker-machine name"
  exit 1
fi

name=$1

if [[ -d "/tmp/syzkaller/$name" ]]; then
  rm -rf "/tmp/syzkaller/$name"
fi

mkdir -p /tmp/syzkaller/"$name"
while true; do
  docker-machine scp -r -d root@"$name":~/workdir/crashes/ /tmp/syzkaller/"$name"/
  docker-machine scp -r -d root@"$name":/tmp/log /tmp/syzkaller/"$name"/log
  sleep 10
done
