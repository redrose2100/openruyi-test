function start_vm()
{
    local vm_name=$1
    LOG_INFO "Start vm ${vm_name}"
    local vm_pid=$(get_vm_pid ${vm_name})
    if [ "${vm_pid}x" == "-1x" ]
    then
        virsh create /home/mf_smoke_test/vm/xml/${vm_name}.xml
    else
        local remote_numa=($(get_remote_numa))
        for remote in ${remote_numa[@]}
        do
            smap_mig_out ${remote} ${vm_pid} 0 1
            set_smap_remote_numa_info -1 ${remote} 0
            wait_proc_mem_numa eq 180 0 ${vm_pid} ${remote}
        done
        smap_remove ${vm_pid} 1
    fi
    LOG_INFO "Vm started succeed"
}

function get_vm_pid()
{
    local vm_name=$1
    local vm_pid=$(pgrep -f "qemu.*${vm_name}," | sort | uniq)
    echo ${vm_pid:- -1}
}

function start_redis()
{
    local port=$1
    shift
    local nids=($@)
    LOG_INFO "Start redis server"
    LOG_INFO "Redis server started succeed"
}

function get_redis_pid()
{
    local port=$1

    local redis_pid=$(ss -tulnp | grep :${port} | grep -oP 'pid=[0-9]+' | awk -F '=' '{print $2}' | sort | uniq)

    echo ${redis_pid:- -1}
}

function start_redis_benchmark()
{
    local port=$1
}

function start_smap_client()
{
    pkill -9 smap_client_nc
    smap_client_nc & disown
}