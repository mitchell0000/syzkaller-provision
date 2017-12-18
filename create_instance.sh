#!/bin/bash

if [ -z "$API_KEY" ]; then
  echo "Missing API_KEY" >&2 
fi

name="kaller"
facility="nrt1"
plan="baremetal_1"
max="0.08"

while getopts ":h?n:f:p:m:" opt; do
  case $opt in
  h|\?)
    echo "usage:" >&2
    echo -e "\t-n name" >&2
    echo -e "\t-f facility_code" >&2
    echo -e "\t-p plan_code (baremetal_?)" >&2
    echo -e "\t-m max price" >&2
    exit 1
    ;;
  n)
    name=$OPTARG;;
  f)
    facility=$OPTARG;;
  p)
    plan="baremetal_$OPTARG";;
  m)
    max=$OPTARG;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    exit 1
    ;;
  *)
    echo "Unimplemented option: -$OPTARG" >&2;
    exit 1;;
  esac
done

echo "Creating $name, at facility $facility, with plan $plan and max price $max..."

docker-machine create "$name" --driver packet --packet-api-key=$API_KEY --packet-os=ubuntu_16_04 --packet-project-id=$PROJECT --packet-facility-code "$facility" --packet-plan "$plan" --packet-spot-price-max "$max"

if [[ ! $? -eq 0 ]]; then
  docker-machine rm -f "$name"
  echo "Failed to create instance."
  exit 1
fi

eval $(docker-machine env "$name")


docker-machine scp ./host_env_setup.sh root@"$name":~/
docker-machine ssh "$name" 'chmod +x ~/host_env_setup.sh && ./host_env_setup.sh'

#start provision the linux host machine
docker-machine scp ./FreeBSD-12.0-CURRENT-amd64.qcow2.xz root@"$name":~/
docker-machine ssh "$name" 'git clone https://github.com/ScottieY/syzkaller-provision ~/provision'

docker-machine ssh "$name" -t 'chmod +x ~/provision/obtain_resources.sh && ~/provision/obtain_resources.sh'

docker-machine ssh "$name" -t 'chmod +x ~/provision/host_vm_setup.sh && ~/provision/host_vm_setup.sh'

echo "Instance created."


docker-machine scp ./freebsd.cfg root@"$name":~/

docker-machine ssh "$name" '~/syzkaller/bin/syz-manager -config ~/freebsd.cfg < /dev/null > /tmp/log 2>&1 &' 

chmod +x ./transfer_file.sh && ./transfer_file.sh "$name"  < /dev/null > /dev/null 2>&1 &
disown
