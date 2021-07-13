echo 1 | sudo tee /sys/kernel/mm/ksm/run
#echo 100000 |  sudo tee /sys/kernel/mm/ksm/pages_to_scan
#echo 100000 |  sudo tee /sys/kernel/mm/ksm/pages_to_scan
echo 1000 |  sudo tee /sys/kernel/mm/ksm/pages_to_scan # used in actual experiment 
#echo 12400 | sudo tee /sys/kernel/mm/ksm/pages_to_scan # used for aggressive ksm 
echo 100 | sudo tee /sys/kernel/mm/ksm/sleep_millisecs # used in actual experiments
#echo 100 | sudo tee /sys/kernel/mm/ksm/sleep_millisecs # used for agressive ksm
#echo 0 | sudo tee /sys/kernel/mm/ksm/sleep_millisecs # used for agressive ksm
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled

echo 1 | sudo tee /sys/kernel/mm/ksm/smart_ksm
echo 15 | sudo tee /sys/kernel/mm/ksm/smart_ksm_nodelist
