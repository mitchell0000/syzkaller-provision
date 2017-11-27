#!/bin/bash

unxz FreeBSD-12.0-CURRENT-amd64.qcow2.xz
qemu-system-x86_64 -m 2048 -hda FreeBSD-12.0-CURRENT-amd64.qcow2 -enable-kvm -netdev user,id=mynet0,host=10.0.2.10,hostfwd=tcp::10022-:22 -device e1000,netdev=mynet0 -nographic &

chmod +x ./bootstrap_img.sh
scp -i ~/.ssh/kaller_key -P 10022 ./bootstrap_img.sh root@localhost:~/
ssh -i ~/.ssh/kaller_key -P 10022 root@localhost '~/bootstrap_img.sh'

scp -i ~/.ssh/kaller_key -P 10022 root@localhost:~/syz-executor syzkaller/bin/freebsd_amd64/
ssh -i ~/.ssh/kaller_key -P 10022 root@localhost 'poweroff'
