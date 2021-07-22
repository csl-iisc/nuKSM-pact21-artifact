CPU1=0
vm1_name="ubuntu_nuksm_1"
vm1_ip=192.168.123.149
vm1_user="akash"
vm1_pass="iamakash"
prepare_vm1_script="sudo mount benchmarks /opt/benchmarks/ -t 9p -o trans=virtio ; echo 0 | sudo tee /proc/sys/kernel/randomize_va_space "
vm1_script_phase2="sleep 1"
#vm1_script_phase3="cd /home/akash/benchmarks/real/XSBench/openmp-threading; time ./XSBench -g 100000 -p 6000000"
vm1_script_phase3="sudo /opt/benchmarks/btree_parallel/BTree"

vm2_name="ubuntu_nuksm_2"
vm2_ip=192.168.123.228
vm2_user="akash"
vm2_pass="iamakash"
prepare_vm2_script="sudo mount benchmarks /opt/benchmarks/ -t 9p -o trans=virtio ; echo 0 | sudo tee /proc/sys/kernel/randomize_va_space"
vm2_script_phase2="sleep 1"
#vm2_script_phase3="cd /home/akash/benchmarks/real/XSBench/openmp-threading; time ./XSBench -g 100000 -p 6000000"
vm2_script_phase3="sudo /opt/benchmarks/btree_parallel/BTree"

time_to_sleep_thres1=20
time_to_sleep_thres2=40
number_of_pages_thres1=100
number_of_pages_thres2=50
threshold1_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres1"
threshold2_script="numactl -C $CPU1 ./helper/codes/bin_inputpages-pin $number_of_pages_thres2"
