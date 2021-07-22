CPU1=0
vm1_name="ubuntu_nuksm_1"
vm1_ip=192.168.123.149
vm1_user="akash"
vm1_pass="iamakash"
vm1_script="cd /home/akash/benchmarks/numa-benchmarks/mysql;./run.sh"
prepare_vm1_script="cd /home/akash/benchmarks/numa-benchmarks/mysql;./prepare_workload.sh"
vm1_script_phase2="cd /home/akash/benchmarks/numa-benchmarks/mysql;python3 complete_script.py filldata"
vm1_script_phase3="cd /home/akash/benchmarks/numa-benchmarks/mysql;time python3 complete_script.py access"

vm2_name="ubuntu_nuksm_2"
vm2_ip=192.168.123.228
vm2_user="akash"
vm2_pass="iamakash"
vm2_script="cd /home/akash/benchmarks/numa-benchmarks/mysql;./run.sh"
prepare_vm2_script="cd /home/akash/benchmarks/numa-benchmarks/mysql;./prepare_workload.sh"
vm2_script_phase2="cd /home/akash/benchmarks/numa-benchmarks/mysql;python3 complete_script.py filldata"
vm2_script_phase3="cd /home/akash/benchmarks/numa-benchmarks/mysql;time python3 complete_script.py access"

time_to_sleep_thres1=20
time_to_sleep_thres2=40
number_of_pages_thres1=100
number_of_pages_thres2=50
threshold1_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres1"
threshold2_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres2"
