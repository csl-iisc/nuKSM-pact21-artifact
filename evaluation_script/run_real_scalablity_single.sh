. config/config.sh
. helpers/virsh_scripts_real.sh

RUN_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DUMP_TIME_FILE_VM1="$RUN_HOME/data_collections/vm1_time"
DUMP_TIME_FILE_VM2="$RUN_HOME/data_collections/vm2_time"
MEMINFO_DUMP_FILE="$RUN_HOME/data_collections/MEMINFO"
TOTAL_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/intial_total"
USED_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/used_total"
FREE_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/free_total"
VM1_SPECIAL_FILE="$RUN_HOME/data_collections/special_file_vm1.csv"
VM2_SPECIAL_FILE="$RUN_HOME/data_collections/special_file_vm2.csv"
NICE_VALUE_1=${REQ_NICE_VALUE_1}
NICE_VALUE_2=${REQ_NICE_VALUE_2}

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
    #sleep 10
    #start_vm $vm2_name
}

#start_vms() {
#    start_vm $vm2_name
#    sleep 10
#    start_vm $vm1_name
#}


prepare_vms() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$prepare_vm1_script" & 
    PREPARE_PID1=$!
    #run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$prepare_vm2_script" &
    #PREPARE_PID2=$!
    sleep 10
}

#prepare_vms() {
#    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$prepare_vm2_script" &
#    PREPARE_PID2=$!
#    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$prepare_vm1_script" & 
#    PREPARE_PID1=$!
#    sleep 10
#}


execute_phase2() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase2"
    #sleep 100
    #run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase2"
}

#execute_phase2() {
#    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase2"
#    sleep 100
#    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase2"
#}

shutdown_vms() {
    shutdown_vm $vm1_name
}

setup_counting_processes() {
    # Start the Perf process bound to the specific VMs
    PID_VM1=`get_virsh_pid $vm1_name`
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_dedup_cpu_usage.sh  > data_collections/cpu_usage &
    PID_COUNTING_CPUUSAGE_DEDUPTHREAD=$!
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_single.sh $PID_VM1 > data_collections/csv_readings_vm &
    PID_COUNTING_VM=$!
    #bash ./helpers/readings_collectors/memory_graph.sh > data_collections/mem_info_timeseries &
    #MEMORY_CONSUMPTION_PID=$!
    #PID_VM1=`get_virsh_pid $vm1_name`
    #PID_VM2=`get_virsh_pid $vm2_name`
    #echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect.sh $PID_VM1 > data_collections/csv_readings_vm1 &
    #PID_COUNTING_VM1=$!
    #echo "PID_COPUNT : VM1 : " $PID_COUNTING_VM1
    #echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect.sh $PID_VM2 > data_collections/csv_readings_vm2 &
    #PID_COUNTING_VM2=$!
    #echo "PID_COPUNT : VM2 : "  $PID_COUNTING_VM2
    # #
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

complete_counting_porcesses() {
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_CPUUSAGE_DEDUPTHREAD
    #kill -9 $MEMORY_CONSUMPTION_PID
    #echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM1"
    #echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM1
    #echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM2"
    #echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM2
}


copy_files_from_vm() {
    copy_file_from_vm_to_host $vm1_ip $vm1_user $vm1_pass "$vm1_run_file" "$VM1_SPECIAL_FILE"
}

# Preparation before starting 
echo "INITIAL" > $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemTotal | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "" >> $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemAvailable | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "----------" >> $MEMINFO_DUMP_FILE
###############################################################
# Setting taskset for ksm 
#pid=`ps aux | grep ksmd  | grep -v grep | awk '{print $2}'`
#taskset -cp 0,3 $pid
#taskset -cp 1 $pid
###############################################################

#Start the VMs
# 1. Start VMs with abundant memory 
# (VM1 on CPU belonging to Node 0 and VM2 on CPU belonging to Node 1)
get_initial_memory_usage
start_vms
setup_counting_processes
#set_vms_priority
###############################################################
sleep 60
# 2. Run WL-P1 on both VMs
prepare_vms
###############################################################
#Run workloads within the VMs
echo run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1"
run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1" &
pid_wl1=$!

wait $pid_wl1
#copy_files_from_vm

cat /proc/meminfo  | grep MemTotal | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "" >> $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemAvailable | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
complete_counting_porcesses
#complete_counting_porcesses_perf
# Shutdown all vms 
shutdown_vms
