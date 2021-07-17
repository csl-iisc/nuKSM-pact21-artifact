bash compile_script.sh
#./binaries/wl-randomreads-inputpages 12000000 > process_log &
./binaries/wl-randomreads-inputpages $1 $2 > process_log &
#./binaries/wl-randomreads-inputpages 12000 > process_log &
disown 
exit 0
