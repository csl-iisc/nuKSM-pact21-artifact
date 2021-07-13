NUM_NODES=2
NUMA_ALLOCATIONS_ONE=()
NUMA_ALLOCATIONS_TWO=()

PID_TO_WATCH1=$1
PID_TO_WATCH2=$2

numa_nodes_info()
{
    counter=$1
    pid1=$2
    target_nodes_info=0
    total_memory_1=`numastat -p $pid1 | grep 'Total' | grep -v 'Node'`
    memory_stat=`free -m | grep 'Mem'`
    NUMA_ALLOCATIONS_ONE[1]=`echo $total_memory_1 | awk '{print $2}'`
    NUMA_ALLOCATIONS_ONE[2]=`echo $total_memory_1 | awk '{print $3}'`
    total=`echo $memory_stat | awk '{print $2}'`
    used=`echo $memory_stat | awk '{print $3}'`
    free=`echo $memory_stat | awk '{print $4}'`
    pages_shared=`cat /sys/kernel/mm/ksm/pages_shared`
    pages_sharing=`cat /sys/kernel/mm/ksm/pages_sharing`
    full_scand=`cat /sys/kernel/mm/ksm/full_scans`

    a=`ps aux | grep ksm  | grep -v grep | awk '{print $2}'`
    b=`ps -o %cpu -p $a`
    cpu_usage_ps=`echo $b | awk '{print $2}'`

    echo $counter,${NUMA_ALLOCATIONS_ONE[1]},${NUMA_ALLOCATIONS_ONE[2]},$total,$used,$free,${pages_shared},${pages_sharing},${full_scand},${cpu_usage_ps}
}

i=0
echo "Time,P0_NODE0,P0_NODE1,TOTAL_MEM,USED,FREE,PAGES_SHARED,PAGES_SHARING,FULL_SCANS"
while true
do
    numa_nodes_info $i $PID_TO_WATCH1
    i=$((i+30))
    sleep 30
done
