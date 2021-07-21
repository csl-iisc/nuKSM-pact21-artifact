PERF_EVENT_LOCAL_DRAM="offcore_resp_DEMAND_DATA_RD.LOCAL_DRAM"
PERF_EVENT_REMOTE_DRAM="offcore_resp_DEMAND_DATA_RD.REMOTE_DRAM"


process_results()
{
    log1=$1
    log2=$2
    CSVREMOTELOCAL1=$3
    CSVREMOTELOCAL2=$4
    generatedunique=`date '+%Y%m%d%j%I%H'`$RANDOM
    grep $PERF_EVENT_LOCAL_DRAM $log1 | grep -v "<not counted>"> /tmp/${generatedunique}local_count_1
    grep $PERF_EVENT_REMOTE_DRAM $log1 | grep -v "<not counted>" > /tmp/${generatedunique}remote_count_1

    grep $PERF_EVENT_LOCAL_DRAM $log2 | grep -v "<not counted>" > /tmp/${generatedunique}local_count_2
    grep $PERF_EVENT_REMOTE_DRAM $log2 | grep -v "<not counted>" > /tmp/${generatedunique}remote_count_2

    echo "python3 parse_local_remote.py /tmp/${generatedunique}local_count_1 /tmp/${generatedunique}local_count_2 /tmp/${generatedunique}remote_count_1 /tmp/${generatedunique}remote_count_2 $CSVREMOTELOCAL1 $CSVREMOTELOCAL2"
    python3 parse_local_remote.py /tmp/${generatedunique}local_count_1 /tmp/${generatedunique}local_count_2 /tmp/${generatedunique}remote_count_1 /tmp/${generatedunique}remote_count_2 $CSVREMOTELOCAL1 $CSVREMOTELOCAL2
}

BASE_DIR="collections_experimnent_data/RESULTS_PERF/EXP01_XSBENCH/5.4.0_KSM_ON/"

CSVREMOTELOCAL1="${BASE_DIR}csv_remote_local_vm1.csv"
CSVREMOTELOCAL2="${BASE_DIR}csv_remote_local_vm2.csv"

OUTFILE1="${BASE_DIR}outfile_1.log"
OUTFILE2="${BASE_DIR}outfile_2.log"
process_results $OUTFILE1 $OUTFILE2 $CSVREMOTELOCAL1 $CSVREMOTELOCAL2
