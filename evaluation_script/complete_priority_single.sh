if [[ ${BENCHMARK} == ""  ]]; then
    echo "BENCHMARK not defined. Please run"
    echo "export BENCHMARK=[BENCHAMRK TO RUN]"
    exit 1
fi

FOLDER="./collections_experimnent_data/PRIORITY_AWARE_EXP/"
echo "Creating Directory ${FOLDER}/${BENCHMARK}"
mkdir -p  ${FOLDER}/${BENCHMARK}/

cd config ;
unlink config.sh
if [[ ${BENCHMARK} == "EXP00_MICROBENCH" ]]; then
    ln -s config_chisel1_micro-onlyacross_small.sh config.sh
elif [[ ${BENCHMARK} == "EXP01_XSBENCH" ]]; then
    ln -s config_chisel1_xsbench.sh config.sh
elif [[ ${BENCHMARK} == "EXP02_SYSBENCHMYSQL" ]]; then
    ln -s config_chisel1_sysbench_mysql.sh config.sh
elif [[ ${BENCHMARK} == "EXP03_CG" ]]; then
    ln -s config_chisel1_npb-cg.C.x.sh config.sh
elif [[ ${BENCHMARK} == "EXP04_BTREE" ]]; then
    ln -s config_chisel1_btree.sh config.sh
fi
cd ../

CONFIGURATIONS_NICE_1=(-20 -20 -20 -16 -11)
CONFIGURATIONS_NICE_2=(-11 -16 -20 -20 -20)

for CONFIG_NUM in ${!CONFIGURATIONS_NICE_1[@]}; do
    start_time=$(date +%s)
    echo "RUN NUM : ${CONFIG_NUM}"
    export PRIORITY_RUN_ENV="yes"
    export REQ_NICE_VALUE_1=${CONFIGURATIONS_NICE_1[${CONFIG_NUM}]} 
    export REQ_NICE_VALUE_2=${CONFIGURATIONS_NICE_2[${CONFIG_NUM}]}
    echo "RUNNING WITH PRIORITY VM1 as ${REQ_NICE_VALUE_1}"
    echo "RUNNING WITH PRIORITY VM2 as ${REQ_NICE_VALUE_2}"
    echo "-----------------------------------------------"
    rm -rf data_collections/*
    #./run_ycsb.sh
    if [[ ${BENCHMARK} == "EXP00_MICROBENCH" ]]; then
        ./run.sh
    elif [[ ${BENCHMARK} == "EXP01_XSBENCH" ]]; then
        ./run_real.sh
    elif [[ ${BENCHMARK} == "EXP02_SYSBENCHMYSQL" ]]; then
        ./run_ycsb.sh
    elif [[ ${BENCHMARK} == "EXP03_CG" ]]; then
        ./run_real.sh
    elif [[ ${BENCHMARK} == "EXP04_BTREE" ]]; then
        ./run_real.sh
    fi

    cp -R data_collections ${FOLDER}/${BENCHMARK}/${CONFIG_NUM}
    rm -rf data_collections/*
    end_time=$(date +%s)
    echo "${BENCHMARK} ${CONFIG_NUM} : $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
    echo "-----------------------------------------------"
    sleep 5
done
