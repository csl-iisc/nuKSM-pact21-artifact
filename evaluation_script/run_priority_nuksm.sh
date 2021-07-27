export TIME_LOG_FILE="prioity_time_log.log"
export BENCHMARK="EXP02_SYSBENCHMYSQL"
bash complete_priority_single.sh 
export BENCHMARK="EXP04_BTREE"
bash complete_priority_single.sh
export BENCHMARK="EXP01_XSBENCH"
bash complete_priority_single.sh
