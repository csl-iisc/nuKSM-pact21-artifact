#FOLDER="./collections_new"
#FOLDER="./collections_experimnent_data/FINAL_DATA/"
#FOLDER="./collections_experimnent_data/FINAL_DATA_4cores/"
#FOLDER="./collections_experimnent_data/FINAL_DATA_4cores_again/"
FOLDER="./collections_experimnent_data/FINAL_DATA_4cores_new/"
FOLDER_EXTRA="5.4.0+_KSMON/"

#drwxrwxr-x  3 akash akash 4096 Oct 27 16:06 EXP00_MICROBENCH/
#drwxrwxr-x  8 akash akash 4096 Nov 17 08:46 EXP01_XSBENCH/
#drwxrwxr-x  9 akash akash 4096 Nov 17 12:57 EXP02_SYSBENCHMYSQL/
#drwxrwxr-x  8 akash akash 4096 Nov 17 16:33 EXP03_CG/
#drwxrwxr-x  6 akash akash 4096 Nov 17 17:37 EXP04_BTREE/
#drwxrwxr-x  4 akash akash 4096 Nov 16 23:42 EXP05_APEX/

mkdir -p ${FOLDER}
cd config 
unlink config.sh
ln -s config_chisel1_xsbench.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP01_XSBENCH/
cp -R data_collections ${FOLDER}/EXP01_XSBENCH/${FOLDER_EXTRA}
rm -rf data_collections/*
sleep 20

cd config
unlink config.sh 
ln -s config_chisel1_npb-cg.C.x.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP03_CG/
cp -R data_collections ${FOLDER}/EXP03_CG/${FOLDER_EXTRA}
sleep 20

#cd config
#unlink config.sh 
#ln -s config_chisel1_sysbench_mysql.sh config.sh
#cd ..
#./run_ycsb.sh
#cp -R data_collections ${FOLDER}/sysbench-mysql/${FOLDER_EXTRA}
#sleep 10 

cd config
unlink config.sh
ln -s config_chisel1_btree_parallel.sh config.sh
cd ..
./run_real.sh
mkdir -p ${FOLDER}/EXP04_BTREE/
cp -R data_collections ${FOLDER}/EXP04_BTREE/${FOLDER_EXTRA}
rm -rf data_collections/*
sleep 20

cd config
unlink config.sh
ln -s config_chisel1_sysbench_mysql.sh config.sh
cd ..
./run_ycsb.sh
mkdir -p ${FOLDER}/EXP02_SYSBENCHMYSQL/
cp -R data_collections ${FOLDER}/EXP02_SYSBENCHMYSQL/${FOLDER_EXTRA}
sleep 20

#cd config
#unlink config.sh
#ln -s config_chisel1_apex.sh config.sh
#cd ..
#./run_real.sh
#mkdir -p ${FOLDER}/EXP05_APEX/
#cp -R data_collections ${FOLDER}/EXP05_APEX/${FOLDER_EXTRA}

cd config
unlink config.sh
ln -s config_chisel1_micro-onlyacross_small.sh config.sh
cd ..
./run.sh
mkdir -p ${FOLDER}/EXP00_MICROBENCH/
cp -R data_collections ${FOLDER}/EXP00_MICROBENCH/${FOLDER_EXTRA}
rm -rf data_collections/*
sleep 20

