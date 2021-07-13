
#echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
#./run_native_priority.sh btree
#cp -R  data_collections collections_experimnent_data/NATIVE_EXP/BTree2_one

#sleep 10
#echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
#./run_native_priority.sh btree
#cp -R  data_collections collections_experimnent_data/NATIVE_EXP/BTree2_two

#sleep 10
#echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
#./run_native_priority.sh btree
#cp -R  data_collections collections_experimnent_data/NATIVE_EXP/BTree2_three

#sleep 10
#echo 2 | sudo tee /proc/sys/kernel/randomize_va_space
#./run_native_priority.sh xsbench
#cp -R  data_collections collections_experimnent_data/NATIVE_EXP/xsbench2_one  

#sleep 10
#echo 2 | sudo tee /proc/sys/kernel/randomize_va_space
#./run_native_priority.sh xsbench
#cp -R  data_collections collections_experimnent_data/NATIVE_EXP/xsbench2_two

#sleep 10
echo 2 | sudo tee /proc/sys/kernel/randomize_va_space
./run_native_priority.sh xsbench
cp -R  data_collections collections_experimnent_data/NATIVE_EXP/xsbench_reverse_priority
