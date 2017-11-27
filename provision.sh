#!/bin/bash

chmod +x ~/provision/obtain_resources.sh
~/provision/obtain_resources.sh

chmod +x ~/provision/host_vm_setup.sh 
~/provision/host_vm_setup.sh

#run syzkaller
