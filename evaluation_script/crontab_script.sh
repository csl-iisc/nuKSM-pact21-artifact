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

KERNEL_VERSION=`uname -r`
if [[ "5.4.0" == "${KERNEL_VERSION}" ]]; then
    mkdir -p collections_experimnent_data/RESULTS_SCALABILITY/
    cp -R data_collections collections_experimnent_data/RESULTS_SCALABILITY/KSM_ON/ 
elif [[ "5.4.0nuKSMMultiTree+" == "${KERNEL_VERSION}" ]]; then
    mkdir -p collections_experimnent_data/RESULTS_SCALABILITY/
    cp -R data_collections collections_experimnent_data/RESULTS_SCALABILITY/nuKSM/
fi
