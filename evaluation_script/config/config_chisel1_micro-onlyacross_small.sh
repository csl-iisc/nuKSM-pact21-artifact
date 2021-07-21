CPU1=0
vm1_name="ubuntu_numa_1"
vm1_ip=192.168.123.149
vm1_user="akash"
vm1_pass="iamakash"
vm1_script="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;./run.sh"
#prepare_vm1_script="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;./prepare_workload-1.sh 600000 10"
prepare_vm1_script="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;./prepare_workload-1.sh 600000 30"
vm1_script_phase2="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;python3 complete_script.py filldata"
vm1_script_phase3="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;/usr/bin/time -f '%s' -p  python3 complete_script.py access"
vm1_run_file="/home/akash/vm_run_file"

vm2_name="ubuntu_numa_2"
vm2_ip=192.168.123.228
vm2_user="akash"
vm2_pass="iamakash"
vm2_script="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;./run.sh"
#prepare_vm2_script="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;./prepare_workload-1.sh 600000 10"
prepare_vm2_script="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;./prepare_workload-1.sh 600000 30"
vm2_script_phase2="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;python3 complete_script.py filldata"
vm2_script_phase3="cd /home/akash/benchmarks/numa-benchmarks/micro-onlyacross;/usr/bin/time -f '%s' -p  python3 complete_script.py access"
vm2_run_file="/home/akash/vm_run_file"


time_to_sleep_thres1=20
time_to_sleep_thres2=40
number_of_pages_thres1=100
number_of_pages_thres2=50
threshold1_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres1"
threshold2_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres2"
