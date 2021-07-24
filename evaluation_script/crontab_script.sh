#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
#cd /home/akash/data/project/ksmautonuma-prj/nuKSM-artifact/evaluation_script
sleep 20
cd ${SCRIPT_DIR}
pwd
cd config;
unlink config.sh
ln -s config_chisel1_xsbench_scalability.sh config.sh
cd ../
./run_real_scalablity.sh > crontab_run_real_scalablity_log 2> errors.txt 
