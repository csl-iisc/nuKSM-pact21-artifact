#FOLDER="./collections_new"
FOLDER="./collections_experimnent_data/PRIORITY_AWARE_EXP_BTREE/"
FOLDER_EXTRA="btree_actual_corrected"
echo "Creating Directory ${FOLDER}/${FOLDER_EXTRA}/"
mkdir -p  ${FOLDER}/${FOLDER_EXTRA}/
echo "Removing all in ${FOLDER}/${FOLDER_EXTRA}/"
rm -rf ${FOLDER}/${FOLDER_EXTRA}/*
#echo 1 | sudo tee /sys/kernel/mm/ksm/priorityaware_ksm

CONFIGURATIONS_NICE_1=(-20 -20 -20 -16 -11)
CONFIGURATIONS_NICE_2=(-11 -16 -20 -20 -20)

for CONFIG_NUM in ${!CONFIGURATIONS_NICE_1[@]}; do
    echo "RUN NUM : ${CONFIG_NUM}"
    export REQ_NICE_VALUE_1=${CONFIGURATIONS_NICE_1[${CONFIG_NUM}]} 
    export REQ_NICE_VALUE_2=${CONFIGURATIONS_NICE_2[${CONFIG_NUM}]}
    echo "RUNNING WITH PRIORITY VM1 as ${REQ_NICE_VALUE_1}"
    echo "RUNNING WITH PRIORITY VM2 as ${REQ_NICE_VALUE_2}"
    echo "-----------------------------------------------"
    rm -rf data_collections/*
    #./run_ycsb.sh
    ./run_real.sh
    cp -R data_collections ${FOLDER}/${FOLDER_EXTRA}/${CONFIG_NUM}
    echo "-----------------------------------------------"
    sleep 5
done

