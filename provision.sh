#!/bin/bash

chmod +x ~/provision/host_env_setup.sh 
~/provision/host_env_setup.sh

chmod 400 ~/.ssh/kaller_key

chmod +x ~/provision/host_vm_setup.sh 
~/provision/host_vm_setup.sh
#run syzkaller
