unlink  configure_ksm_at_begining.sh
if [[ ${1} == "" ]]; then
    echo "Usage: ${0} [KSM_ON/KSM_OFF/nuKSM]"
    exit 1
elif [[ ${1} != "KSM_ON" &&  ${1} != "KSM_OFF" && ${1} != "nuKSM" ]]; then
    echo "Usage: ${0} [KSM_ON/KSM_OFF/nuKSM]"
    exit 2
else
    if [[ ${1} == "KSM_OFF" ]]; then
        ln -s configure_ksm_at_begining_ksmoff.sh configure_ksm_at_begining.sh
    else
        ln -s configure_ksm_at_begining_ksmon.sh configure_ksm_at_begining.sh
    fi
    FOLDER_EXTRA="5.4.0_${1}"
fi

FOLDER="./collections_experimnent_data/RESULTS_PERF/"
TIME_LOG_FILE="timelog.log"
#echo ${FOLDER}${FOLDER_EXTRA}

export PERF_RUN="yes"
export CPU_LIST_1="0-3"
export CPU_LIST_2="18-21"

start_time=$(date +%s)
mkdir -p ${FOLDER}
cd config 
unlink config.sh
ln -s config_chisel1_xsbench.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP01_XSBENCH/
cp -R data_collections ${FOLDER}/EXP01_XSBENCH/${FOLDER_EXTRA}
rm -rf data_collections/*
end_time=$(date +%s)
echo "EXP01_XSBENCH : $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
sleep 10

start_time=$(date +%s)
cd config
unlink config.sh 
ln -s config_chisel1_npb-cg.C.x.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP03_CG/
cp -R data_collections ${FOLDER}/EXP03_CG/${FOLDER_EXTRA}
rm -rf data_collections/*
end_time=$(date +%s)
echo "EXP03_CG: $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
sleep 10

start_time=$(date +%s)
cd config
unlink config.sh 
ln -s config_chisel1_sysbench_mysql.sh config.sh
cd ..
./run_ycsb.sh
mkdir -p ${FOLDER}/EXP02_SYSBENCHMYSQL/
cp -R data_collections ${FOLDER}/EXP02_SYSBENCHMYSQL/${FOLDER_EXTRA}
rm -rf data_collections/*
end_time=$(date +%s)
echo "EXP02_SYSBENCHMYSQL: $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
sleep 10 

start_time=$(date +%s)
cd config
unlink config.sh
ln -s config_chisel1_btree.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP04_BTREE/
cp -R data_collections ${FOLDER}/EXP04_BTREE/${FOLDER_EXTRA}
rm -rf data_collections/*
end_time=$(date +%s)
echo "EXP04_BTREE: $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
sleep 10

start_time=$(date +%s)
cd config
unlink config.sh
ln -s config_chisel1_micro-onlyacross_small.sh config.sh
cd ..
./run.sh
mkdir -p ${FOLDER}/EXP00_MICROBENCH/
cp -R data_collections ${FOLDER}/EXP00_MICROBENCH/${FOLDER_EXTRA}
rm -rf data_collections/*
end_time=$(date +%s)
echo "EXP00_MICROBENCH: $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
sleep 10
