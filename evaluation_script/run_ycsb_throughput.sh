#!/bin/bash

. config/config.sh
. helpers/virsh_scripts_real.sh

RUN_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DUMP_TIME_FILE_VM1="$RUN_HOME/data_collections/vm1_time"
DUMP_TIME_FILE_VM2="$RUN_HOME/data_collections/vm2_time"
MEMINFO_DUMP_FILE="$RUN_HOME/data_collections/MEMINFO"
TOTAL_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/intial_total"
USED_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/initial_used"
FREE_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/initial_free"
RUN_1_OP="$RUN_HOME/data_collections/vm1_run_op"
RUN_2_OP="$RUN_HOME/data_collections/vm2_run_op"
NICE_VALUE="3"


SUDO_PASSWD="iamakash"

#------------------PERF REQUIREMENTS ---------------------------------#
PERF="/home/akash/perf_5.4"
OUTFILE1="$RUN_HOME/data_collections/outfile_1.log"
OUTFILE2="$RUN_HOME/data_collections/outfile_2.log"

PERF_EVENT_LOCAL_DRAM="offcore_resp_DEMAND_DATA_RD.LOCAL_DRAM"
PERF_EVENT_REMOTE_DRAM="offcore_resp_DEMAND_DATA_RD.REMOTE_DRAM"
CSVREMOTELOCAL1="$RUN_HOME/data_collections/csv_remote_local_vm1.csv"
CSVREMOTELOCAL2="$RUN_HOME/data_collections/csv_remote_local_vm2.csv"

#-----------------------------------------------------------------------#

CPU1=43
CPU2=57

echo $SUDO_PASSWD | sudo -S bash configure_ksm_at_begining.sh

start_vms() {
    start_vm $vm1_name
    sleep 20
    start_vm $vm2_name
    sleep 20
    PID_VM1=`get_virsh_pid $vm1_name`
    PID_VM2=`get_virsh_pid $vm2_name`
    #echo $SUDO_PASSWD | sudo -S renice -n 6 -p $PID_VM1
    #echo $SUDO_PASSWD | sudo -S renice -n 4 -p $PID_VM2
}

prepare_vms() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$prepare_vm1_script" &
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$prepare_vm2_script" &
    sleep 10
    #wait $PREPARE_PID1
    #wait $PREPARE_PID2
}

execute_phase2() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase2"
#    EXECUTE_PHASE2_PID1=$!
#    sleep 60
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase2"
#    EXECUTE_PHASE2_PID2=$!
#    wait $EXECUTE_PHASE2_PID1
#    wait $EXECUTE_PHASE2_PID2
}

shutdown_vms() {
    shutdown_vm $vm1_name
    shutdown_vm $vm2_name   
}

set_vms_priority() {
    echo "Setting VMs priorities"
    PID_VM1=`get_virsh_pid $vm1_name`
    PID_VM2=`get_virsh_pid $vm2_name`

    renice -n $NICE_VALUE  -p $PID_VM1
}



setup_counting_processes() {
    # Start the Perf process bound to the specific VMs
    PID_VM1=`get_virsh_pid $vm1_name` 
    PID_VM2=`get_virsh_pid $vm2_name`
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_all.sh $PID_VM1 $PID_VM2 > ${RUN_HOME}/data_collections/csv_readings_vm &
    PID_COUNTING_VM=$!
}

setup_counting_processes_read_process () {
    # Start the Perf process bound to the specific VMs
    PID_VM1=`get_virsh_pid $vm1_name`
    PID_VM2=`get_virsh_pid $vm2_name`
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_all.sh $PID_VM1 $PID_VM2 > ${RUN_HOME}/data_collections/csv_readings_vm_read &
    PID_COUNTING_VM=$!
}

setup_counting_read_processes_perf() {
    # Start the Perf process bound to the specific VMs    
    PID_VM1=`get_virsh_pid $vm1_name`
    PID_VM2=`get_virsh_pid $vm2_name`
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_all.sh $PID_VM1 $PID_VM2 > ${RUN_HOME}/data_collections/csv_readings_vm &
    PID_COUNTING_VM=$!
    echo $SUDO_PASSWD | sudo -S $PERF kvm stat -a -C $CPU1 -x, -o $OUTFILE1 --append -e cpu/event=0xbb,umask=0x1,offcore_rsp=0x07B0000001,name=offcore_resp_DEMAND_DATA_RD.REMOTE_DRAM/,cpu/event=0xbb,umask=0x1,offcore_rsp=0x078C000001,name=offcore_resp_DEMAND_DATA_RD.LOCAL_DRAM/ -p $PID_VM1 -I 30000 &
    PERF_PID1=$!
    echo $SUDO_PASSWD | sudo -S $PERF kvm stat -a -C $CPU2 -x, -o $OUTFILE2 --append -e cpu/event=0xbb,umask=0x1,offcore_rsp=0x07B0000001,name=offcore_resp_DEMAND_DATA_RD.REMOTE_DRAM/,cpu/event=0xbb,umask=0x1,offcore_rsp=0x078C000001,name=offcore_resp_DEMAND_DATA_RD.LOCAL_DRAM/ -p $PID_VM2 -I 30000 &
    PERF_PID2=$!
}


complete_counting_porcesses() {
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM
}

process_results()
{
    log1=$1
    log2=$2
    generatedunique=`date '+%Y%m%d%j%I%H'`$RANDOM
    grep $PERF_EVENT_LOCAL_DRAM $log1 | grep -v "<not counted>"> /tmp/${generatedunique}local_count_1
    grep $PERF_EVENT_REMOTE_DRAM $log1 | grep -v "<not counted>" > /tmp/${generatedunique}remote_count_1

    grep $PERF_EVENT_LOCAL_DRAM $log2 | grep -v "<not counted>" > /tmp/${generatedunique}local_count_2
    grep $PERF_EVENT_REMOTE_DRAM $log2 | grep -v "<not counted>" > /tmp/${generatedunique}remote_count_2

    python3 parse_local_remote.py /tmp/${generatedunique}local_count_1 /tmp/${generatedunique}local_count_2 /tmp/${generatedunique}remote_count_1 /tmp/${generatedunique}remote_count_2 $CSVREMOTELOCAL1 $CSVREMOTELOCAL2
}


complete_counting_porcesses_perf() {
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PERF_PID1
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PERF_PID2
    process_results $OUTFILE1 $OUTFILE2
}



get_initial_memory_usage() {
    memory_stat=`free -m | grep 'Mem'`
    total=`echo $memory_stat | awk '{print $2}'`
    used=`echo $memory_stat | awk '{print $3}'`
    free=`echo $memory_stat | awk '{print $4}'`
    echo $total > $TOTAL_MEMORY_INITIAL_FILE
    echo $used > $USED_MEMORY_INITIAL_FILE
    echo $free > $FREE_MEMORY_INITIAL_FILE
}

copy_files_from_vm() {
    copy_file_from_vm_to_host $vm1_ip $vm1_user $vm1_pass "$vm1_run_file" "$RUN_1_OP"
    copy_file_from_vm_to_host $vm2_ip $vm2_user $vm2_pass "$vm2_run_file" "$RUN_2_OP"
}

# Preparation before starting 
echo "INITIAL" > $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemTotal | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "" >> $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemAvailable | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "----------" >> $MEMINFO_DUMP_FILE
###############################################################

#Start the VMs
# 1. Start VMs with abundant memory 
# (VM1 on CPU belonging to Node 0 and VM2 on CPU belonging to Node 1)
get_initial_memory_usage
start_vms
set_vms_priority
###############################################################
setup_counting_processes
sleep 40
# 2. Run WL-P1 on both VMs
prepare_vms
###############################################################
# 3. Invoke WL-P2 on VM1 and VM2 in an interval of 10 seconds.
execute_phase2
sleep 20
###############################################################
SLEEP_INTERVAL=2000 # 4500 for MySQL
echo "Sleeping $SLEEP_INTERVAL after phase 2"
sleep $SLEEP_INTERVAL
echo "Begining Phase 3"
complete_counting_porcesses
mkdir -p collections_experimnent_data/FINAL_DATA_THROUGHPUT/MYSQL/
variable=0
while [ $variable -le 100 ]
do
    echo "Inside Loop ${variable}"
    setup_counting_processes_read_process
    #setup_counting_read_processes_perf
    # Run workloads within the VMs
    echo run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" 
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" & 
    pid_wl1=$!
    #sleep 10
    echo run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" 
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" &
    pid_wl2=$!
    wait $pid_wl1
    wait $pid_wl2
    cat /proc/meminfo  | grep MemTotal | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
    echo "" >> $MEMINFO_DUMP_FILE
    cat /proc/meminfo  | grep MemAvailable | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
    complete_counting_porcesses
    #complete_counting_porcesses_perf
    copy_files_from_vm
    cd $RUN_HOME
    mkdir -p ${RUN_HOME}/collections_experimnent_data/FINAL_DATA_THROUGHPUT/MYSQL/
    cp -R ${RUN_HOME}/data_collections/ collections_experimnent_data/FINAL_DATA_THROUGHPUT/MYSQL/${variable}
    rm -rf ${RUN_HOME}/data_collections/*
    variable=$(( $variable+1 ))
done
# Run workloads within the VMs : For cleanup of thje VMS
echo run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm2_script_cleanup" 
run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm2_script_cleanup"  &
pid_wl1_cl=$!
#sleep 60
echo run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_cleanup" 
run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_cleanup"  &
pid_wl2_cl=$!

wait $pid_wl1_cl
wait $pid_wl2_cl
# Shutdown all vms 
shutdown_vms
