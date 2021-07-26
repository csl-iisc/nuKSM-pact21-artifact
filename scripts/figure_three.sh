BASE_DIR="../evaluation_script/collections_experimnent_data/RESULTS/"
KSM_OFF_FOLDER="5.4.0_KSMOFF"
KSM_ON_FOLDER="5.4.0_KSMON"
nuKSM_FOLDER="5.4.0+_KSMON"
FRACTION_SALE="scale=4"
SEPARATOR=","
ECHO="echo -e "

${ECHO} "BENCHMARK${SEPARATOR}KSM_ON${SEPARATOR}KSM_ON${SEPARATOR}KSM_OFF${SEPARATOR}KSM_OFF"
${ECHO} "BENCHMARK${SEPARATOR}Instance-0${SEPARATOR}Instance-1${SEPARATOR}Instance-0${SEPARATOR}Instance-1"
#XSBench
VM1_RUNTIME_OFF=`grep "Runtime:" ${BASE_DIR}EXP01_XSBENCH/${KSM_OFF_FOLDER}/vm1_time  | awk '{print $2}'`
VM2_RUNTIME_OFF=`grep "Runtime:" ${BASE_DIR}EXP01_XSBENCH/${KSM_OFF_FOLDER}/vm2_time  | awk '{print $2}'`
VM1_RUNTIME_ON=`grep "Runtime:" ${BASE_DIR}EXP01_XSBENCH/${KSM_ON_FOLDER}/vm1_time  | awk '{print $2}'`
VM2_RUNTIME_ON=`grep "Runtime:" ${BASE_DIR}EXP01_XSBENCH/${KSM_ON_FOLDER}/vm2_time  | awk '{print $2}'`
#${ECHO} "XSBENCH,$((VM1_RUNTIME_OFF/VM1_RUNTIME_OFF)),$((VM2_RUNTIME_OFF/VM1_RUNTIME_OFF)),$((VM1_RUNTIME_ON/VM1_RUNTIME_OFF)),$((VM2_RUNTIME_ON/VM1_RUNTIME_OFF))"
VM1_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM1_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
${ECHO} "XSBENCH${SEPARATOR}${VM1_RUNTIME_OFF_NORM}${SEPARATOR}${VM2_RUNTIME_OFF_NORM}${SEPARATOR}${VM1_RUNTIME_ON_NORM}${SEPARATOR}${VM2_RUNTIME_ON_NORM}"

#BTree
VM1_RUNTIME_OFF=`grep "matches" ${BASE_DIR}EXP04_BTREE/${KSM_OFF_FOLDER}/vm1_time | awk '{print $5}'`
VM2_RUNTIME_OFF=`grep "matches" ${BASE_DIR}EXP04_BTREE/${KSM_OFF_FOLDER}/vm2_time | awk '{print $5}'`
VM1_RUNTIME_ON=`grep "matches" ${BASE_DIR}EXP04_BTREE/${KSM_ON_FOLDER}/vm1_time | awk '{print $5}'`
VM2_RUNTIME_ON=`grep "matches" ${BASE_DIR}EXP04_BTREE/${KSM_ON_FOLDER}/vm2_time | awk '{print $5}'`
VM1_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM1_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
${ECHO} "BTREE${SEPARATOR}${VM1_RUNTIME_OFF_NORM}${SEPARATOR}${VM2_RUNTIME_OFF_NORM}${SEPARATOR}${VM1_RUNTIME_ON_NORM}${SEPARATOR}${VM2_RUNTIME_ON_NORM}"


#MySQL
timeone=`grep "total time:" ${BASE_DIR}EXP02_SYSBENCHMYSQL/${KSM_OFF_FOLDER}/vm1_run_op  | awk '{print $3}'`
VM1_RUNTIME_OFF=${timeone//s}
timetwo=`grep "total time:" ${BASE_DIR}EXP02_SYSBENCHMYSQL/${KSM_OFF_FOLDER}/vm2_run_op  | awk '{print $3}'`
VM2_RUNTIME_OFF=${timetwo//s}
timeone=`grep "total time:" ${BASE_DIR}EXP02_SYSBENCHMYSQL/${KSM_ON_FOLDER}/vm1_run_op  | awk '{print $3}'`
VM1_RUNTIME_ON=${timeone//s}
timetwo=`grep "total time:" ${BASE_DIR}EXP02_SYSBENCHMYSQL/${KSM_ON_FOLDER}/vm2_run_op  | awk '{print $3}'`
VM2_RUNTIME_ON=${timetwo//s}
VM1_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM1_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
${ECHO} "MySQL${SEPARATOR}${VM1_RUNTIME_OFF_NORM}${SEPARATOR}${VM2_RUNTIME_OFF_NORM}${SEPARATOR}${VM1_RUNTIME_ON_NORM}${SEPARATOR}${VM2_RUNTIME_ON_NORM}"

#CG
VM1_RUNTIME_OFF=`grep "Time in seconds" ${BASE_DIR}EXP03_CG/${KSM_OFF_FOLDER}/vm1_time  | awk '{print $5}'`
VM2_RUNTIME_OFF=`grep "Time in seconds" ${BASE_DIR}EXP03_CG/${KSM_OFF_FOLDER}/vm2_time  | awk '{print $5}'`
VM1_RUNTIME_ON=`grep "Time in seconds" ${BASE_DIR}EXP03_CG/${KSM_ON_FOLDER}/vm1_time  | awk '{print $5}'`
VM2_RUNTIME_ON=`grep "Time in seconds" ${BASE_DIR}EXP03_CG/${KSM_ON_FOLDER}/vm2_time  | awk '{print $5}'`
VM1_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM1_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
${ECHO} "CG${SEPARATOR}${VM1_RUNTIME_OFF_NORM}${SEPARATOR}${VM2_RUNTIME_OFF_NORM}${SEPARATOR}${VM1_RUNTIME_ON_NORM}${SEPARATOR}${VM2_RUNTIME_ON_NORM}"

#RandomAccess
VM1_RUNTIME_OFF=`grep real ${BASE_DIR}EXP00_MICROBENCH/${KSM_OFF_FOLDER}/vm1_time | grep real | awk '{print $2}'`
VM2_RUNTIME_OFF=`grep real ${BASE_DIR}EXP00_MICROBENCH/${KSM_OFF_FOLDER}/vm2_time | grep real | awk '{print $2}'`
VM1_RUNTIME_ON=`grep real ${BASE_DIR}EXP00_MICROBENCH/${KSM_ON_FOLDER}/vm1_time | grep real | awk '{print $2}'`
VM2_RUNTIME_ON=`grep real ${BASE_DIR}EXP00_MICROBENCH/${KSM_ON_FOLDER}/vm2_time | grep real | awk '{print $2}'`
VM1_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_OFF_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_OFF}/${VM1_RUNTIME_OFF}" | bc -l`
VM1_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM1_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
VM2_RUNTIME_ON_NORM=`echo "${FRACTION_SALE};${VM2_RUNTIME_ON}/${VM1_RUNTIME_OFF}" | bc -l`
${ECHO} "RandomAccess${SEPARATOR}${VM1_RUNTIME_OFF_NORM}${SEPARATOR}${VM2_RUNTIME_OFF_NORM}${SEPARATOR}${VM1_RUNTIME_ON_NORM}${SEPARATOR}${VM2_RUNTIME_ON_NORM}"

