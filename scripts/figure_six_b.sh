. ./parse_benchmark_file.sh

BASE_DIR="../evaluation_script/collections_experimnent_data/RESULTS_PERF/"
KSM_OFF_FOLDER="5.4.0_KSM_OFF"
KSM_ON_FOLDER="5.4.0_KSM_ON"
nuKSM_FOLDER="5.4.0_nuKSM"
FRACTION_SALE="scale=4"
SEPARATOR=","
ECHO="echo -e "

#BENCHMARKS=("EXP04_BTREE" "EXP01_XSBENCH" "EXP02_SYSBENCHMYSQL")
#BENCHMARKS_OP_FILE_VM1=("vm1_time" , "vm1_time" , "vm1_run_op")
#BENCHMARKS_OP_FILE_VM2=("vm2_time" , "vm2_time" , "vm2_run_op")

BENCHMARKS=("EXP00_MICROBENCH" "EXP01_XSBENCH" "EXP02_SYSBENCHMYSQL" "EXP03_CG" "EXP04_BTREE")
BENCHMARKS_OP_FILE_VM1="csv_remote_local_vm1.csv"
BENCHMARKS_OP_FILE_VM2="csv_remote_local_vm2.csv"

echo "KSM_Instance-0_Local , KSM_Instance-0_Remote , KSM_Instance-1_Local , KSM_Instance-1_Remote , nuKSM_Instance-0_Local , nuKSM_Instance-0_Remote , nuKSM_Instance-1_Local , nuKSM_Instance-1_Remote"
for BENCHMARK_NUMBER in ${!BENCHMARKS[@]};do
    BENCHMARK=${BENCHMARKS[${BENCHMARK_NUMBER}]}
    python3 parse_csv_local_remote_file.py  ${BASE_DIR}${BENCHMARK}/${KSM_ON_FOLDER}/${BENCHMARKS_OP_FILE_VM1} ${BASE_DIR}${BENCHMARK}/${KSM_ON_FOLDER}/${BENCHMARKS_OP_FILE_VM2} ${BASE_DIR}${BENCHMARK}/${nuKSM_FOLDER}/${BENCHMARKS_OP_FILE_VM1} ${BASE_DIR}${BENCHMARK}/${nuKSM_FOLDER}/${BENCHMARKS_OP_FILE_VM2}
done
