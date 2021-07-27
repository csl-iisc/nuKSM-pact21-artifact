echo 0 | sudo tee /sys/kernel/mm/ksm/run
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
