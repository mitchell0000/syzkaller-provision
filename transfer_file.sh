#!/bin/bash
if [[ ! $1 ]];then
  echo "Missing docker-machine name"
  exit 1
fi

name=$1
mkdir -p /tmp/"$name"
while true; do
  docker-machine scp -r -d root@"$name":~/workdir/crashes/ /tmp/"$name"/
  sleep 10
done