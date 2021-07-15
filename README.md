nuKSM PACT'21 Artifact Evaluation
=====================================

This repository contains scripts and other supplementary material
for the PACT'21 artifact evaluation of the paper **nuKSM: NUMA-aware Memory 
De-duplication for Multi-socket Servers** by Akash Panda, Ashish Panwar, 
Arkaprava Basu

The scripts can be used to reproduce the data in the paper.

Authors
-------
 
 * Akash Panda (Indian Institute of Science)
 * Ashish Panwar (Indian Institute of Science)
 * Arkaprava Basu (Indian Institute of Science)


License
-------

See LICENSE file.


Directory Structure
-------------------

 * `evaluation_script` contains all the scripts that will be used to generate the motivation 
    and evaluation results
 * `resources` has all the configuration files used in our experiments


Hardware Dependencies
---------------------

Some of the experiment requires a machine with at least 196GB of memory  
*per* NUMA node.


Software Dependencies
---------------------

The scripts, compilation and binaries are tested on Ubuntu 16.04 LTS. Other 
Linux distributions may work, but are not tested.

In addition to the packages shipped with Ubuntu 16.04 LTS the following 
packets are required:

```
$ sudo apt-get install build-essential libncurses-dev \
                     bison flex libssl-dev libelf-dev \
                     libnuma-dev python3 python3 python3-pip \
                     python3-matplotlib python3-numpy \
                     git wget kernel-package fakeroot ccache \
                     libncurses5-dev wget pandoc libevent-dev \
                     libreadline-dev python3-setuptools \
             libtool autoconf automake autotools-dev \
             pkg-config libev-dev qemu-kvm libvirt-bin \
             bridge-utils virtinst virt-manager
```                       

Deploying
---------

Just clone the artifact on the machine you want to run it on.

Obtaining Source Code and Compile
---------------------------------

If you don't want to compile from scratch, you can skip this section.

The source code for the Linux kernel and evaluated worloads are available on 
GitHub and included as public submodules. To obtain the source code, initialize the git submodules.

```
$ cd nuKSM-pact21-artifact
$ git submodule init
$ git submodule update
```

To compile nuKSM linux kernel:
```
$ cd nuKSMLinuxKernel
$ make -j 70
$ sudo make modules_install
$ sudo make install 
```

Install and Create Virtual Machine Configurations
-------------------------------------------------

Install a virtual machine using command line (choose ssh-server when prompted for package installation):

```
$ virt-install \
--name ubuntu_nuksm_1 \
--ram 60000 \
--disk path=./ubuntu_nuksm_1.qcow2,size=50 \
--vcpus 4 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'


$ virt-install \
--name ubuntu_nuksm_2 \
--ram 60000 \
--disk path=./ubuntu_nuksm_2.qcow2,size=50 \
--vcpus 4 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```
Once installed, use the following script to prepare three VM configuration files:
```
1. <vcpu> </vcpu> -- to update the number of CPUs to be allocated to the VM (all or single socket)
2. <memory> </memory> -- to update the amount of memory to be allocated to the VM (all or single socket)
3. <cputune> <cputune> -- to bind vCPUs to pCPUs
4. <numatune> </numatune> -- to setup the number of guest NUMA nodes (required only for **numa-visible.xml**)
5. <cpu><numa> </numa></cpu> -- to bind vCPUs to guest NUMA nodes (required only for **numa-visible.xml**)
```
Refer to `nuKSM-pact21-artifact/resources/vm_xmls/` for all VM configurations used in the paper.

Generate Data For Figures
-------------------------
Edit the /etc/default/grub file to change the GRUB_DEFAULT
```
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 5.4.0
```

Run update-grub
```
$ sudo update-grub
```

Reboot the machine
```
$ sudo reboot
```

After rebooting, now we shall run the benchmarks with the following scripts
```
$ cd evaluation_script
$ bash complete_evaluation_fairness.sh KSM_OFF 
$ bash complete_evaluation_fairness.sh KSM_ON
```

Now edit the /etc/default/grub file to change the 
Comment all lines with 
```
GRUB_DEFAULT=
```
Add 
```
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 5.4.0+"
```

Now we have to run the following script to run the benchmarks with nuKSM
```
$ cd evaluation_script
$ bash complete_evaluation_fairness.sh nuKSM
```

Reboot the machine
```
$ sudo reboot
```

After rebooting, now we shall run the below commands to run the prioriy runs
```
$ cd evaluation_script
$ bash complete_priority.sh
```


