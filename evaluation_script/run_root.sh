. config/config.sh
. helpers/virsh_scripts.sh

RUN_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DUMP_TIME_FILE_VM1="$RUN_HOME/data_collections/vm1_time"
DUMP_TIME_FILE_VM2="$RUN_HOME/data_collections/vm2_time"
MEMINFO_DUMP_FILE="$RUN_HOME/data_collections/MEMINFO"
SUDO_PASSWD="iamakash"

bash ./configure_ksm_at_begining.sh

start_vms() {
    start_vm $vm1_name
    sleep 10
    start_vm $vm2_name
}

prepare_vms() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$prepare_vm1_script"  &
    PREPARE_PID1=$!
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$prepare_vm2_script"  &
    PREPARE_PID2=$!
    sleep 10
    #wait $PREPARE_PID1
    #wait $PREPARE_PID2
}

execute_phase2() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase2"
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase2"
}

shutdown_vms() {
    shutdown_vm $vm1_name
    shutdown_vm $vm2_name   
}

setup_counting_processes() {
    # Start the Perf process bound to the specific VMs
    bash ./helpers/readings_collectors/memory_graph.sh > data_collections/mem_info_timeseries &
    MEMORY_CONSUMPTION_PID=$!
    PID_VM1=`get_virsh_pid $vm1_name`
    PID_VM2=`get_virsh_pid $vm2_name`
    bash ./helpers/readings_collectors/collect.sh $PID_VM1 > data_collections/csv_readings_vm1 &
    PID_COUNTING_VM1=$!
    echo "PID_COPUNT : VM1 : " $PID_COUNTING_VM1
    bash ./helpers/readings_collectors/collect.sh $PID_VM2 > data_collections/csv_readings_vm2 &
    PID_COUNTING_VM2=$!
    echo "PID_COPUNT : VM2 : "  $PID_COUNTING_VM2
    # #
}

complete_counting_porcesses() {
    kill -9 $PID_COUNTING_VM1
    echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM1"
    kill -9 $PID_COUNTING_VM1
    echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM2"
    kill -9 $PID_COUNTING_VM2
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
start_vms
###############################################################
setup_counting_processes
sleep 20
# 2. Run WL-P1 on both VMs
prepare_vms
###############################################################
# 3. Invoke WL-P2 on VM1 and VM2 in an interval of 10 seconds.
execute_phase2
sleep 20
###############################################################
#setup_counting_processes
#setup_counting_processes
#echo "PID_ COUNTING1 : " $PID_COUNTING_VM1
#echo "PID_ COUNTING1 : " $PID_COUNTING_VM2

echo "Sleeping 400 after phase 2"
sleep 400
bash ./configure_ksm_before_launch.sh
echo "KSM params set. Sleeping 100 before execution of phase 3"
sleep 100

# Run workloads within the VMs
echo run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1"
run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1" &
pid_wl1=$!
sleep 10
echo run_workloads_inside_vm_op_redirection $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" "$DUMP_TIME_FILE_VM2"
run_workloads_inside_vm_op_redirection $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" "$DUMP_TIME_FILE_VM2" &
pid_wl2=$!

#sleep $time_to_sleep_thres1
#$threshold1_script &
#pid_thres1=$!
#sleep $time_to_sleep_th res2
#$threshold2_script &
#pid_thres2=$!
# Wait for workloads to complete
wait $pid_wl1
wait $pid_wl2
#kill -9 $pid_thres1
#kill -9 $pid_thres2
sleep 20
cat /proc/meminfo  | grep MemTotal | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "" >> $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemAvailable | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
complete_counting_porcesses
# Shutdown all vms 
shutdown_vms
