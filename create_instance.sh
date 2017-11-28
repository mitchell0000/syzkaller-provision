#!/bin/bash

docker-machine create kaller --driver packet --packet-api-key=$API_KEY --packet-os=ubuntu_16_04 --packet-project-id=$PROJECT --packet-facility-code "nrt1" --packet-plan "baremetal_1" --packet-spot-price-max "0.08"
eval $(docker-machine env kaller)


docker-machine scp ./host_env_setup.sh root@kaller:~/
docker-machine ssh kaller 'chmod +x ~/host_env_setup.sh && ./host_env_setup.sh'

#start provision the linux host machine
docker-machine scp ./FreeBSD-12.0-CURRENT-amd64.qcow2.xz root@kaller:~/
docker-machine ssh kaller 'git clone https://github.com/ScottieY/syzkaller-provision ~/provision'

docker-machine ssh kaller -t 'chmod +x ~/provision/obtain_resources.sh && ~/provision/obtain_resources.sh'

docker-machine ssh kaller -t 'chmod +x ~/provision/host_vm_setup.sh && ~/provision/host_vm_setup.sh'

echo "Instance created."


docker-machine scp ./freebsd.cfg root@kaller:~/
