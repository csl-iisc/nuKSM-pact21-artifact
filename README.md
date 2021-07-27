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
$ cd /path/to/nuKSM-pact21-artifact/
$ git submodule init
$ git submodule update
$ make
```

On your test machine, compile and install
the vmlinux binary from ./nuKSM-linux/
```
$ git checkout v5.4.0
$ cp -v /boot/config-$(uname -r) .config
$ make menuconfig
$ make -j $(nproc)
$ sudo make modules_install
$ sudo make install
$ git checkout nuKSM_SingleTree
$ make -j $(nproc)
$ sudo make modules_install
$ sudo make install 
$ git checkout nuKSM_MultiTree
$ make -j $(nproc)
$ sudo make modules_install
$ sudo make install
```



Install and Create Virtual Machine Configurations
-------------------------------------------------
Install a virtual machine using libvirt on your test machine. An example using 
command line installation is provided below (choose sshserver when prompted 
for package installation). Create an user with username `nuksm` and password `nuksm` 
when asked for during the installation process

```
$ cd VM_images/;
 
$ virt-install 
--name ubuntu_nuksm_1 \
--ram 60000 \
--disk path=./ubuntu_nuksm_1.qcow2,size=50 \
--vcpus 4 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://archive.ubuntu.com/ubuntu/dists/\
bionic/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'

$ virt-clone --original ubuntu_nuksm_1 \ 
--name ubuntu_nuksm_2 \
--auto-clone

$ cd -
```
Create a network for our Virtual machines: 
```
$ cd resources/network_xml/
$ virsh net-define network-01.xml  
$ virsh net-start network-01
$ cd -
```

Once installed, run the below command to generate the required VM configurations. 
The appropriate configuration will be loaded by run scripts themselves.
```
$ cd scripts
$ sudo python3 gen_vmconfigs.py 0 1
$ sudo ./load_vmconfigs.sh
$ cd -
```
Refer to `nuKSM-pact21-artifact/resources/vm_xmls/` for all VM configurations used in the paper.

Once the network is setup and the configurations are loaded, restart the vms.
```
$ virsh shutdown ubuntu_nuksm_1
$ virsh shutdown ubuntu_nuksm_2
$ virsh start ubuntu_nuksm_1
$ virsh start ubuntu_nuksm_2
```

Setup the VMs
-----------------
Login to the machines to setup the benchmarks inside the VMs. IPs
of ubuntu nuksm 1 will be 192.168.123.149 and of ubuntu nuksm 2
will be 192.168.123.228. Perform the following steps on both the
VMs to setup the benchamrks and environment.

```
$ ssh nuksm@[IP OF THE VM]
$ sudo apt install net-tools mysql-server libmysqlclient-dev sysbench git make gcc g++ gfortran
$ sudo systemctl disable mysql
```

Add these lines to /etc/mysql/mysql.conf.d/mysqld.cnf
```
tmp_table_size=20G
max_heap_table_size=20G
```

Run
```
$ sudo service mysql restart
```

Switch user to root to setup mysql user. Run the following commands
-------------------------------------------------------------------
```
# mysql -u root -p

mysql> CREATE USER "nuksm"@"localhost" IDENTIFIED BY "nuksm";
mysql> CREATE DATABASE nuksmbench;
mysql> GRANT ALL PRIVILEGES ON nuksmbench . * TO 'nuksm'@'localhost';
mysql> FLUSH PRIVILEGES;
```

Clone the repository https://github.com/csl-iisc/nuKSM-pact21-artifact in /home/nuksm/nuKSM-artifact and compile the benchmarks.
```
$ git clone https://github.com/csl-iisc/nuKSM-pact21-artifact nuKSM-artifact
$ cd nuKSM-artifact
$ make 
```

Experiment workflow
-------------------
We provide various scripts to run various experiments as performed
in the paper. All the automation scripts to launch the benchmarks are
in the bash ./evaluation_script/ directory.
```
# cd evaluation_scripts/
```
1) **Launching Fairness experiments:** 
Boot the Linux kernel v5.4.0, and run the following scripts.
```
# bash run_evaluation_fairness.sh KSM_OFF
# bash run_evaluation_fairness_perf.sh KSM_OFF
# bash run_evaluation_fairness.sh KSM_ON
# bash run_evaluation_fairness_perf.sh KSM_ON
```
Now boot with the Linux Kernel 5.4.0nuKSMSingleTree+ kernel,
and run the following scripts.
```
# cd evaluation_scripts/
# bash run_evaluation_fairness.sh nuKSM
# bash run_evaluation_fairness_perf.sh nuKSM
```

2) **Launching priority inversion experiments:**
Boot from Linux kernel v5.4.0, and run the following scripts.
```
# bash run_priority_inversion.sh KSM_ON
```
Now boot from Linux kernel 5.4.0nuKSMSingleTree+, and run
the following scripts.
```
# bash run_priority_nuksm.sh
```

3) **Launching scalability experiments:**
We need to launch these experiments automatically on machine startup 
to accurately capture CPU utilization of KSM and nuKSM (we use `ps` 
to record the average CPU utilization). First we re-configure to bind 
both VMs to node-0 and edit the crontab script:
```
# cd scripts/
# python3 ./gen_vmconfigs.py 0 0
# ./load_vmconfigs.sh
# crontab -e
```
Add the following line to crontab:
```
@reboot /path/to/nuKSM-pact21-artifact/evaluation_script/crontab_script.sh
```

We need to limit the memory on the machine to 175 GiB in order to run this 
experiment. To do that, we have to change the `/etc/default/grub` file 
and set `GRUB_CMDLINE_LINUX` to `"mem=175G"`.

Reboot the machine and wait for the experiment to finish. It takes around 
1600 seconds to get completed. Next, reboot with Linux Kernel 
5.4.0nuKSMMultiTree+ and wait for experiments to finish. Now remove the 
added line from crontab, so that the next reboot will not launch the experiment.

Gathering the results
---------------------
Now all our experiment’s results are ready, and we would run scripts to gather 
the results required for various Figures. We provide individual scripts for each 
figure in the paper, and a common script to launch all of them in one go 
in ./scripts/ directory. Once you have run the benchmarks on the target machine, 
you can go into the scripts directory and execute the scripts to generate the data 
for the figures as described below.

To generate all figures, move in into the ./scripts/ directory.
```
$ cd scripts/
```
and execute
```
$ bash generate_all.sh
```

To generate data for a single figure, do:

 * Figure-3a - `bash figure_three_a.sh`
 * Figure-3b - `bash figure_three_b.sh`
 * Figure-4 - `bash figure_four.sh`
 * Figure-6a - `bash figure_six_a.sh`
 * Figure-6b - `bash figure_six_b.sh`
 * Figure-7 - `bash figure_seven.sh`
 * Figure-8a - `bash figure_eight_a.sh`
 * Figure-8b - `bash figure_eight_b.sh`
 * Figure-8c - `bash figure_eight_c.sh`

If you run bash ./generate_all.sh, you will find the
generated CSVs inside `/path/to/nuKSM-pact-artifact/results` directory.

Evaluation and expected results
-------------------------------
Once you’ve completed all or partial experiments, you can compare
the outcomes with the expected results shown in the figures in
the paper.

