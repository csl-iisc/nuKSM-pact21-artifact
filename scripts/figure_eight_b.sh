BASE_DIR="../evaluation_script/collections_experimnent_data/RESULTS_SCALABILITY/"
KSM_FOLDER="KSM_ON"
NUKSM_FOLDER="nuKSM"

python3 parse_oom_experiment.py  ${BASE_DIR}${KSM_FOLDER}/csv_readings_vm ${BASE_DIR}${NUKSM_FOLDER}/csv_readings_vm DEDUP_MEM
