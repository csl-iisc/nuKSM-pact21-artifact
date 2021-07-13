#SCRIPT_HOME=$(readlink -f "`dirname $(readlink -f "$0")`")
SCRIPT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
start_vm()
{
	# $1 is the name of the VM
	virsh start $1
}

shutdown_vm()
{
	virsh shutdown $1
}

get_virsh_pid()
{
	#cat /var/run/libvirt/qemu/$1.pid 
    temp_pid_no=`ps ax | grep $1 | grep -v grep | awk '{print $1}'`
    echo $temp_pid_no
}

run_workloads_inside_vm()
{
    vm_ip=$1
    vm_user=$2
    vm_pass=$3
    script_to_run_inside_vm=$4
    cd $SCRIPT_HOME
    pwd
    ./ssh_script_bash_sshpass $vm_ip $vm_user $vm_pass "$script_to_run_inside_vm"
    cd - 
}

run_workloads_inside_vm_op_redirection()
{
    vm_ip=$1
    vm_user=$2
    vm_pass=$3
    script_to_run_inside_vm=$4
    file_for_op_redirection=$5
    cd $SCRIPT_HOME
    pwd
    ./ssh_script_bash_sshpass $vm_ip $vm_user $vm_pass "$script_to_run_inside_vm" > "$file_for_op_redirection"
}

copy_file_from_vm_to_host() 
{
    vm_ip=$1
    vm_user=$2
    vm_pass=$3
    file_in_vm=$4
    path_in_host=$5
    cd $SCRIPT_HOME
    pwd
    ./scp_script_bash_reverse $vm_ip $vm_user "$file_in_vm" $vm_pass "$path_in_host"
}

