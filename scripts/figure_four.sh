. ./parse_benchmark_file.sh

BASE_DIR="../evaluation_script/collections_experimnent_data/RESULTS_THOUGHPUTEXP/EXP04_BTREE/5.4.0_KSM_ON/"

FRACTION_SALE="scale=4"
SEPARATOR=","
ECHO="echo -e "

THROUGHPUT_OP_FILE1="vm1_run_op"
THROUGHPUT_OP_FILE2="vm2_run_op"

python3 parse_throughput.py  ${BASE_DIR}${THROUGHPUT_OP_FILE1} ${BASE_DIR}${THROUGHPUT_OP_FILE2}
