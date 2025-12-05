source $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/smap_command.sh
source $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/proc_command.sh

function set_case_var()
{
    local var_key=$1
    shift
    local var_value=$@
    eval "export __var__$var_key=($var_value)"
}


function get_local_numa()
{
    lscpu | grep -oP 'NUMA node\d+\s+CPU\(s\):\s+\S+$' | sed -E 's@.*node([0-9]+).*@\1@g'
}

function get_remote_numa()
{
    lscpu | grep -oP 'NUMA node\d+\s+CPU\(s\):\s+$' | sed -E 's@.*node([0-9]+).*@\1@g'
}

function get_proc_mem_numa()
{
    local pid=$1
    local nid=$2
    local numa_mem_stat=($(numastat -c -p ${pid} 0 2>/dev/null | sed -n '3p;$p' | sed -E 's@Node\ +@Node@g'))
    for ((i=0; i<${#numa_mem_stat[@]}; i++))
    do
        if [ "${numa_mem_stat[i]}"x == "Node${nid}"x ]
        then
            echo ${numa_mem_stat[$(($i + ${#numa_mem_stat[@]} / 2))]}
            return
        fi
    done
    echo 0
}