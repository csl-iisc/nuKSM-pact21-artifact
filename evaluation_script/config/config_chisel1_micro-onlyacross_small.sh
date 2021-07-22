CPU1=0
vm1_name="ubuntu_nuksm_1"
vm1_ip=192.168.123.149
vm1_user="nuksm"
vm1_pass="nuksm"
vm1_script="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;./run.sh"
#prepare_vm1_script="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;./prepare_workload-1.sh 600000 10"
prepare_vm1_script="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;./prepare_workload-1.sh 600000 30"
vm1_script_phase2="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;python3 complete_script.py filldata"
vm1_script_phase3="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;/usr/bin/time -f '%s' -p  python3 complete_script.py access"
vm1_run_file="/home/nuksm/vm_run_file"

vm2_name="ubuntu_nuksm_2"
vm2_ip=192.168.123.228
vm2_user="nuksm"
vm2_pass="nuksm"
vm2_script="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;./run.sh"
#prepare_vm2_script="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;./prepare_workload-1.sh 600000 10"
prepare_vm2_script="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;./prepare_workload-1.sh 600000 30"
vm2_script_phase2="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;python3 complete_script.py filldata"
vm2_script_phase3="cd /home/nuksm/nuKSM-artifact/benchmarks/randomAccess;/usr/bin/time -f '%s' -p  python3 complete_script.py access"
vm2_run_file="/home/nuksm/vm_run_file"


time_to_sleep_thres1=20
time_to_sleep_thres2=40
number_of_pages_thres1=100
number_of_pages_thres2=50
threshold1_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres1"
threshold2_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres2"
