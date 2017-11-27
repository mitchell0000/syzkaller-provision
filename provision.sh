#!/bin/bash

docker-machine create kaller --driver packet --packet-api-key=$API_KEY --packet-os=ubuntu_16_04 --packet-project-id=$PROJECT --packet-facility-code "nrt1" --packet-plan "baremetal_1" --packet-spot-price-max "0.08"
eval $(docker-machine env kaller)

chmod +x host_env_setup.sh 
docker-machine scp ./host_env_setup.sh root@kaller:~/
docker-machine ssh root@kaller '~/host_env_setup.sh'

docker-machine scp FreeBSD-12.0-CURRENT-amd64.qcow2.xz root@kaller:~/

chmod +x host_vm_setup.sh 
scp ./host_vm_setup.sh root@kaller:~/
ssh root@linux '~/host_vm_setup.sh'

#run syzkaller
