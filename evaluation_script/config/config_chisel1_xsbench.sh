CPU1=0
vm1_name="ubuntu_numa_1"
vm1_ip=192.168.123.149
vm1_user="nuksm"
vm1_pass="nuksm"
prepare_vm1_script="sleep 1"
vm1_script_phase2="sleep 1"
#vm1_script_phase3="cd /home/akash/benchmarks/real/XSBench/openmp-threading; time ./XSBench -g 100000 -p 6000000"
#vm1_script_phase3="cd /home/akash/benchmarks/real/XSBench/openmp-threading; time ./XSBench -g 20000 -p 18000000" #20GB Workload
vm1_script_phase3="cd /home/nuksm/nuKSM-artifact/benchmarks/XSBench/src ; time ./XSBench -g 20000 -p 72000000"

vm2_name="ubuntu_numa_2"
vm2_ip=192.168.123.228
vm2_user="nuksm"
vm2_pass="nuksm"
prepare_vm2_script="sleep 1"
vm2_script_phase2="sleep 1"
#vm2_script_phase3="cd /home/akash/benchmarks/real/XSBench/openmp-threading; time ./XSBench -g 100000 -p 6000000"
vm2_script_phase3="cd /home/nuksm/nuKSM-artifact/benchmarks/XSBench/src ; time ./XSBench -g 20000 -p 72000000" #20GB Workload

time_to_sleep_thres1=20
time_to_sleep_thres2=40
number_of_pages_thres1=100
number_of_pages_thres2=50
threshold1_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres1"
threshold2_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres2"
