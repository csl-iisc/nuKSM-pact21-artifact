. config/config.sh
. helpers/virsh_scripts_real.sh

RUN_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DUMP_TIME_FILE_VM1="$RUN_HOME/data_collections/vm1_time"
DUMP_TIME_FILE_VM2="$RUN_HOME/data_collections/vm2_time"
MEMINFO_DUMP_FILE="$RUN_HOME/data_collections/MEMINFO"
TOTAL_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/intial_total"
USED_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/used_total"
FREE_MEMORY_INITIAL_FILE="$RUN_HOME/data_collections/free_total"
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
#    sleep 10
    start_vm $vm2_name
}

#start_vms() {
#    start_vm $vm2_name
#    sleep 10
#    start_vm $vm1_name
#}


prepare_vms() {
    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$prepare_vm1_script" & 
    PREPARE_PID1=$!
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$prepare_vm2_script" &
    PREPARE_PID2=$!
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
#    sleep 100
    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase2"
}

#execute_phase2() {
#    run_workloads_inside_vm $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase2"
#    sleep 100
#    run_workloads_inside_vm $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase2"
#}

shutdown_vms() {
    shutdown_vm $vm1_name
    shutdown_vm $vm2_name   
}

set_vms_priority() {
    echo "Setting VMs priorities"
    PID_VM1=`get_virsh_pid $vm1_name` 
    PID_VM2=`get_virsh_pid $vm2_name`
    echo "renice -n $NICE_VALUE_1 -p $PID_VM1"
    renice -n $NICE_VALUE_1 -p $PID_VM1
    echo "renice -n $NICE_VALUE_2 -p $PID_VM2"
    renice -n $NICE_VALUE_2 -p $PID_VM2
    #renice -n $NICE_VALUE  -p $PID_VM1
}

setup_counting_processes() {
    # Start the Perf process bound to the specific VMs
    PID_VM1=`get_virsh_pid $vm1_name` 
    PID_VM2=`get_virsh_pid $vm2_name`
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_all.sh $PID_VM1 $PID_VM2 > data_collections/csv_readings_vm &
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

setup_counting_processes_perf() {    
    # Start the Perf process bound to the specific VMs    
    PID_VM1=`get_virsh_pid $vm1_name`    
    PID_VM2=`get_virsh_pid $vm2_name`    
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect_all.sh $PID_VM1 $PID_VM2 > data_collections/csv_readings_vm &    
    PID_COUNTING_VM=$!    
    echo $SUDO_PASSWD | sudo -S $PERF kvm stat -a -C $CPU1 -x, -o $OUTFILE1 --append -e cpu/event=0xbb,umask=0x1,offcore_rsp=0x07B0000001,name=offcore_resp_DEMAND_DATA_RD.REMOTE_DRAM/,cpu/event=0xbb,umask=0x1,offcore_rsp=0x078C000001,name=offcore_resp_DEMAND_DATA_RD.LOCAL_DRAM/ -p $PID_VM1 -I 30000 &    
    PERF_PID1=$!    
    echo $SUDO_PASSWD | sudo -S $PERF kvm stat -a -C $CPU2 -x, -o $OUTFILE2 --append -e cpu/event=0xbb,umask=0x1,offcore_rsp=0x07B0000001,name=offcore_resp_DEMAND_DATA_RD.REMOTE_DRAM/,cpu/event=0xbb,umask=0x1,offcore_rsp=0x078C000001,name=offcore_resp_DEMAND_DATA_RD.LOCAL_DRAM/ -p $PID_VM2 -I 30000 &    
    PERF_PID2=$!    
    #bash ./helpers/readings_collectors/memory_graph.sh > data_collections/mem_info_timeseries &    
    #MEMORY_CONSUMPTION_PID=$!    
    #PID_VM1=`get_virsh_pid $vm1_name`    
    #PID_VM2=`get_virsh_pid $vm2_name`    
    #echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect.sh $PID_VM1 > data_collections/csv_readings_vm1 &    
    #PID_COUNTING_VM1=$!    
    #echo "PID_COPUNT : VM1 : " $PID_COUNTING_VM1    
    #echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect.sh $PID_VM2 > data_collections/csv_readings_vm2 &    
    #PID_COUNTING_VM2=$!    
    #echo "PID_COPUNT : VM2 : "  $PID_COUNTING_VM2    # #
}

complete_counting_porcesses() {
    echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM
    #kill -9 $MEMORY_CONSUMPTION_PID
    #echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM1"
    #echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM1
    #echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM2"
    #echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM2
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
    #kill -9 $MEMORY_CONSUMPTION_PID
    #echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM1"
    #echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM1
    #echo "Executing : echo $SUDO_PASSWD | sudo -S pkill -SIGINT -P $PID_COUNTING_VM2"
    #echo $SUDO_PASSWD | sudo -S pkill -9 -P $PID_COUNTING_VM2
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
#set_vms_priority
###############################################################
setup_counting_processes
#setup_counting_processes_perf
sleep 60
# 2. Run WL-P1 on both VMs
prepare_vms
###############################################################
# 3. Invoke WL-P2 on VM1 and VM2 in an interval of 10 seconds.
#execute_phase2
#sleep 20
###############################################################
#setup_counting_processes
#setup_counting_processes
#echo "PID_ COUNTING1 : " $PID_COUNTING_VM1
#echo "PID_ COUNTING1 : " $PID_COUNTING_VM2

#echo "Sleeping 1500 after phase 2"
#sleep 1500
#echo $SUDO_PASSWD | sudo -S bash configure_ksm_before_launch.sh
#echo "KSM params set. Sleeping 100 before execution of phase 3"
#sleep 1000


#Run workloads within the VMs
echo run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1"
run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1" &
pid_wl1=$!
#sleep 10
echo run_workloads_inside_vm_op_redirection $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" "$DUMP_TIME_FILE_VM2"
run_workloads_inside_vm_op_redirection $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" "$DUMP_TIME_FILE_VM2" &
pid_wl2=$!

# Run workloads within the VMs OPPOSITE ORDER
#echo run_workloads_inside_vm_op_redirection $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" "$DUMP_TIME_FILE_VM2"
#run_workloads_inside_vm_op_redirection $vm2_ip $vm2_user $vm2_pass "$vm2_script_phase3" "$DUMP_TIME_FILE_VM2" &
#pid_wl2=$!
#sleep 10
#echo run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1"
#run_workloads_inside_vm_op_redirection $vm1_ip $vm1_user $vm1_pass "$vm1_script_phase3" "$DUMP_TIME_FILE_VM1" &
#pid_wl1=$!


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
cat /proc/meminfo  | grep MemTotal | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
echo "" >> $MEMINFO_DUMP_FILE
cat /proc/meminfo  | grep MemAvailable | awk {'print $2 " " $3'} >> $MEMINFO_DUMP_FILE
complete_counting_porcesses
#complete_counting_porcesses_perf
# Shutdown all vms 
shutdown_vms
