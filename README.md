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

 * `precompiled` contains the downloaded binaries
 * `build` contains the locally compiled binaries
 * `sources` contains the source code of the binaries
 * `datasets` contains the datasets required for the binaries
 * `scripts` contains scripts to run the experiments
 * `bin` points to the used binaries for the evaluation (you can use 
   `scripts/toggle_build.sh` to switch between precompiled and locally 
   compined binaries)


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

**For deploying on a local machine only.**

```
$ vmitosis-asplos21-artifact/scripts/deploy.sh
```

Pre-Compiled Binaries
---------------------

This repository also contains the pre-compiled binaries under `vmitosis-asplos21-artifact/precompiled.`
There are several binaries available:

 * `bench_*` are the benchmarks used in the paper
 * `page_table_dump/numactl/` are helper utilities
 * `mini_probe/micro_probe` are used to discover NUMA topolgy
 * `linux-*.deb` are the linux kernel image and headers with vMitosis modifications

If you only plan to use the pre-compiled binaries, install vMitosis kernel headers and image, and
boot your target machine with vMitosis kernel before running any experiments.

```
$ dpkg -i precompiled/linux-headers-4.17.0-mitosis+_4.17.0-mitosis+-3_amd64.deb
$ dpkg -i precompiled/linux-image-4.17.0-mitosis+_4.17.0-mitosis+-3_amd64.deb
```


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
$ virt-install --name ubuntu_numa_1 --ram 4096 --disk path=/home/akash/nuKSM_ubuntu_numa1.qcow2,size=50 --vcpus 4 --os-type linux --os-variant generic --network bridge=virbr0 --graphics none --console pty,target_type=serial --location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' --extra-args 'console=ttyS0,115200n8 serial'
$ virt-install --name ubuntu_numa_2 --ram 4096 --disk path=/home/akash/nuKSM_ubuntu_numa2.qcow2,size=50 --vcpus 4 --os-type linux --os-variant generic --network bridge=virbr0 --graphics none --console pty,target_type=serial --location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' --extra-args 'console=ttyS0,115200n8 serial'
```
Once installed, use the following script to prepare three VM configuration files:
```
1. <vcpu> </vcpu> -- to update the number of CPUs to be allocated to the VM (all or single socket)
2. <memory> </memory> -- to update the amount of memory to be allocated to the VM (all or single socket)
3. <cputune> <cputune> -- to bind vCPUs to pCPUs
4. <numatune> </numatune> -- to setup the number of guest NUMA nodes (required only for **numa-visible.xml**)
5. <cpu><numa> </numa></cpu> -- to bind vCPUs to guest NUMA nodes (required only for **numa-visible.xml**)
```

The guest OS needs to be booted with vmitosis kernel image. The same can also be configured with "os" tag
in the XML files as follows:
```
  <os>
    <type arch='x86_64' machine='pc-i440fx-eoan-hpb'>hvm</type>
    <kernel>/boot/vmlinuz-5.4.0-nuKSM+</kernel>
    <initrd>/boot/initrd.img-5.4.0-nuKSM+</initrd>
    <cmdline>console=ttyS0 root=/dev/sda1</cmdline>
    <boot dev='hd'/>
  </os>
```

Refer to `nuKSM-pact21-artifact/resources/vm_xmls/` for all VM configurations used in the paper.

