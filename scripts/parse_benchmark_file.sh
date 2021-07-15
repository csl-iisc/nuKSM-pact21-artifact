#EXP00_MICROBENCH  EXP01_XSBENCH  EXP02_SYSBENCHMYSQL  EXP03_CG  EXP04_BTREE


PARSE_EXP00_MICROBENCH()
{
    FILE=$1
    VM_RUNTIME=`grep "real" ${BASE_DIR}EXP00_MICROBENCH/${KSM_ON_FOLDER}/vm1_time | awk '{print $2}'`
    echo ${VM_RUNTIME}
}

PARSE_EXP01_XSBENCH()
{
    FILE=$1
    VM_RUNTIME=`grep "Runtime:" ${FILE}  | awk '{print $2}'`
    echo ${VM_RUNTIME}
}

PARSE_EXP02_SYSBENCHMYSQL()
{
    FILE=$1
    timeone=`grep "total time:" ${FILE}  | awk '{print $3}'`
    VM_RUNTIME=${timeone//s}
    echo ${VM_RUNTIME}
}

PARSE_EXP03_CG()
{
    FILE=$1
    VM_RUNTIME=`grep "Time in seconds" ${FILE}  | awk '{print $5}'`
    echo ${VM_RUNTIME}
}

PARSE_EXP04_BTREE()
{
    FILE=$1
    VM_RUNTIME=`grep "matches" ${FILE} | awk '{print $5}'`
    echo ${VM_RUNTIME}
}

