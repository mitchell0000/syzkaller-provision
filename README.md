# syzkaller-provision

`create_instance.sh` (running on the manager instance) 
  - creates packet instance, transfer vm image and provisioning scripts.
  
`host_env_setup.sh` (running on linux host instance) 
  - installs required packages

`obtain_resources.sh` (runing on linux host instance) 
  - configures GO environement
  - download syzkaller and build binaries
  
`host_vm_setup.sh` (running on linux host instance)
  - configure vm image
  - retrieve executor built in the FreeBSD guest instance
  
`bootstrap_img.sh` (running on FreeBSD guest instance)
  - build executor
