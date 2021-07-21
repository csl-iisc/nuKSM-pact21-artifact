CPU1=0
vm1_name="ubuntu_numa_1"
vm1_ip=192.168.123.149
vm1_user="nuksm"
vm1_pass="nuksm"
prepare_vm1_script="sudo systemctl start mysql"
vm1_script_phase2="sysbench --db-driver=mysql  --mysql-user=nuksm --mysql-password=nuksm --mysql-db=nuksmbench --table_size=40000000 --mysql_storage_engine=memory --rand-type=uniform --rand-seed=1 /home/nuksm/nuKSM-artifact/benchmarks/sysbench/src/lua/oltp_read_only.lua prepare"
vm1_script_phase3="sysbench --threads=100  --db-driver=mysql  --mysql-user=nuksm --mysql-password=nuksm --mysql-db=nuksmbench --table_size=40000000 --mysql_storage_engine=memory --rand-type=uniform --rand-seed=1 --point_selects=100000 /home/nuksm/nuKSM-artifact/benchmarks/sysbench/src/lua/oltp_read_only.lua run > /home/nuksm/OpRun.out"
vm1_script_cleanup="sysbench --db-driver=mysql  --mysql-user=nuksm --mysql-password=nuksm --mysql-db=nuksmbench --table_size=40000000 --mysql_storage_engine=memory --rand-type=uniform --rand-seed=1 /home/nuksm/nuKSM-artifact/benchmarks/sysbench/src/lua/oltp_read_only.lua cleanup"
vm1_run_file="/home/nuksm/OpRun.out"

vm2_name="ubuntu_numa_2"
vm2_ip=192.168.123.228
vm2_user="nuksm"
vm2_pass="nuksm"
prepare_vm2_script="sudo systemctl start mysql"
vm2_script_phase2="sysbench --db-driver=mysql  --mysql-user=nuksm --mysql-password=nuksm --mysql-db=nuksmbench --table_size=40000000 --mysql_storage_engine=memory --rand-type=uniform --rand-seed=1 /home/nuksm/nuKSM-artifact/benchmarks/sysbench/src/lua/oltp_read_only.lua prepare"
vm2_script_phase3="sysbench --threads=100  --db-driver=mysql  --mysql-user=nuksm --mysql-password=nuksm --mysql-db=nuksmbench --table_size=40000000 --mysql_storage_engine=memory --rand-type=uniform --rand-seed=1 --point_selects=100000 /home/nuksm/nuKSM-artifact/benchmarks/sysbench/src/lua/oltp_read_only.lua run > /home/nuksm/OpRun.out"
vm2_script_cleanup="sysbench --db-driver=mysql  --mysql-user=nuksm --mysql-password=nuksm --mysql-db=nuksmbench --table_size=40000000 --mysql_storage_engine=memory --rand-type=uniform --rand-seed=1 /home/nuksm/nuKSM-artifact/benchmarks/sysbench/src/lua/oltp_read_only.lua cleanup"
vm2_run_file="/home/nuksm/OpRun.out"

time_to_sleep_thres1=20
time_to_sleep_thres2=40
number_of_pages_thres1=100
number_of_pages_thres2=50
threshold1_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres1"
threshold2_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres2"
