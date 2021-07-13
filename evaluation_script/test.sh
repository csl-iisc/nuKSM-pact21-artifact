SUDO_PASSWD="iamakash"
func_0() {
    echo $SUDO_PASSWD | sudo -S bash ./helpers/readings_collectors/collect.sh 116280  > data_collections/csv_readings_vm1 &
    ps --ppid $! -o pid= | awk '{print $1}' > /tmp/pid_here
    cat /tmp/pid_here
}

func_2() {
    echo $PID_COUNTING_VM1
}

func_0
func_2
