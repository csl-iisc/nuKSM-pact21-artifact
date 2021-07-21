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

FOLDER="./collections_experimnent_data/RESULTS_THOUGHPUTEXP/"
TIME_LOG_FILE="timelog.log"
#echo ${FOLDER}${FOLDER_EXTRA}

start_time=$(date +%s)
cd config
unlink config.sh
ln -s config_chisel1_btree_throughput.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP04_BTREE/
cp -R data_collections ${FOLDER}/EXP04_BTREE/${FOLDER_EXTRA}
rm -rf data_collections/*
end_time=$(date +%s)
echo "EXP04_BTREE: $(($end_time-$start_time))" >> ${TIME_LOG_FILE}
sleep 10
