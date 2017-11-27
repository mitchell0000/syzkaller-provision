#!/bin/bash

docker-machine create kaller --driver packet --packet-api-key=$API_KEY --packet-os=ubuntu_16_04 --packet-project-id=$PROJECT --packet-facility-code "nrt1" --packet-plan "baremetal_1" --packet-spot-price-max "0.08"
eval $(docker-machine env kaller)

docker-machine ssh 'git clone https://github.com/ScottieY/syzkaller-provision ~/provision'
docker-machine scp FreeBSD-12.0-CURRENT-amd64.qcow2.xz root@kaller:~/

#start provision the linux host machine
docker-machine ssh 'chmod +x ~/provision/provision.sh && ./provision/provision.sh'
