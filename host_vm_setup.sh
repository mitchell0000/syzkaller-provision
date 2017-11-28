#!/bin/bash

# configure vm and image

unxz ~/FreeBSD-12.0-CURRENT-amd64.qcow2.xz

qemu-system-x86_64 -m 2048 -net nic -net user,host=10.0.2.10,hostfwd=tcp::10022-:22 -display none -serial stdio -no-reboot -numa node,nodeid=0,cpus=0-1 -numa node,nodeid=1,cpus=2-3 -smp sockets=2,cores=2,threads=1 -enable-kvm -hda ~/FreeBSD-12.0-CURRENT-amd64.qcow2 &
## need to fix qemu not running in background in script

chmod +x ~/provision/bootstrap_img.sh
cp ~/provision/kaller_key ~/.ssh/kaller_key
chmod 400 ~/.ssh/kaller_key

scp -o StrictHostKeyChecking=no -i ~/.ssh/kaller_key -P 10022 ~/provision/bootstrap_img.sh root@localhost:~/
ssh -o StrictHostKeyChecking=no -i ~/.ssh/kaller_key -p 10022 root@localhost '~/bootstrap_img.sh'

scp -o StrictHostKeyChecking=no -i ~/.ssh/kaller_key -P 10022 root@localhost:~/syz-executor ~/syzkaller/bin/freebsd_amd64/
ssh -o StrictHostKeyChecking=no -i ~/.ssh/kaller_key -p 10022 root@localhost 'poweroff'

echo "Executor generated."
