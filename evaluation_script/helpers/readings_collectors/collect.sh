NUM_NODES=2
NUMA_ALLOCATIONS=()

PID_TO_WATCH=$1

numa_nodes_info()
{
    counter=$1
    pid=$2
    target_nodes_info=0
    total_memory=`numastat -p $pid| grep 'Total' | grep -v 'Node'`
    NUMA_ALLOCATIONS[1]=`echo $total_memory | awk '{print $2}'`
    NUMA_ALLOCATIONS[2]=`echo $total_memory | awk '{print $3}'`
    echo $counter,${NUMA_ALLOCATIONS[1]},${NUMA_ALLOCATIONS[2]}
}

i=1
while true
do
    numa_nodes_info $i $PID_TO_WATCH
    i=$((i+1))
    sleep 30
done
