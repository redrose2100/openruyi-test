function __smap_command_get_res()
{
    local command="$@"
    LOG_INFO "Exec smap command: ${command}"
    local command_res=$(echo "${command}" | nc -U /tmp/smap_nc_socket.sock)
    LOG_INFO "Got smap command response: $(echo ${command_res} | xargs echo)"
    echo $command_res
}

function __smap_command_get_rect()
{
    local command="$@"
    local res=$(__smap_command_get_res $command)
    echo "${res}" | sed -E 's@.*ret\(([^\)]+)\).*@\1@g'
}

function smap_init()
{
    local page_type=$1
    __smap_command_get_rect "smap smap_init $page_type"
}

function set_smap_run_mode()
{
    local run_mode=$1
    __smap_command_get_rect "smap set_smap_run_mode $run_mode"
}

function set_smap_remote_numa_info()
{
    local src_nid=$1
    local dst_nid=$2
    local available_mem=$3
    __smap_command_get_rect "smap set_smap_remote_numa_info $src_nid $dst_nid $available_mem"
}

function smap_mig_out()
{
    local dest_nid=$1
    local pid=$2
    local ratio=$3
    local pid_type=$4
    __smap_command_get_rect "smap smap_mig_out $dest_nid $pid $ratio $pid_type"
}

function smap_mig_out_sync()
{
    local dest_nid=$1
    local pid=$2
    local ratio=$3
    local mem_size=$4
    local migrate_mode=$5
    local pid_type=$6
    local wait_time=$7
    __smap_command_get_rect "smap smap_mig_out_sync $dest_nid $pid $ratio $mem_size $migrate_mode $pid_type $wait_time"
}

function smap_mig_back()
{
    local src_nid=$1
    local dest_nid=$2
    shift 2
    local memids=($@)
    local res=()
    for mem_id in ${memids[@]}
    do
        local pa=$(cat /sys/devices/obmm/${mem_id}/import_info/pa 2>/dev/null | awk '{print strtonum($1)}')
        local size=$(cat /sys/devices/obmm/${mem_id}/size 2>/dev/null | awk '{print strtonum($1)}')
        local pa_end=$(($pa + $size))
        local retry_index=(1 2 3)
        local mig_back_res=-11
        for _ in ${retry_index[@]}
        do
            local mig_back_res=$(__smap_command_get_rect "smap smap_mig_back $src_nid $dest_nid $pa $pa_end")
            if [ "${mig_back_res}x" != "-11x" ]
            then
                break
            fi
            sleep 15
        done
        res=(${res[@]} ${mig_back_res})
    done
    echo ${res[@]}
}

function smap_remove()
{
    local pid=$1
    local pid_type=$2
    __smap_command_get_rect "smap smap_remove $pid $pid_type"
}

function smap_enable_node()
{
    local enable=$1
    local nid=$2
    __smap_command_get_rect "smap smap_enable $enable $nid"
}

function smap_query_vm_freq()
{
    local pid=$1
    local data_flag=$2
    local length=$3
    local no_print=$4
    local page_start=$5
    local page_end=$6
    __smap_command_get_rect "smap smap_query_vm_freq $pid $data_flag $length $no_print $page_start $page_end"
}

function smap_enable_process_migrate()
{
    local enable=$1
    local flags=$2
    local length=$3
    local pid_str=$4
    __smap_command_get_rect "smap smap_enable_process_migrate $enable $flags $length $pid_str"
}


function smap_migrate_pid_remote_numa()
{
    local src_nid=$1
    local dst_nid=$2
    local length=$3
    local pid_str=$4
    __smap_command_get_rect "smap smap_migrate_pid_remote_numa $src_nid $dst_nid $length $pid_str"
}

function smap_migrate_remote_numa()
{
    local src_nid=$1
    local dest_nid=$2
    local count=$3
    shift 3
    local memids=($@)
    local mem_locations=()
    for mem_id in ${memids[@]}
    do
        local pa=$(cat /sys/devices/obmm/${mem_id}/import_info/pa 2>/dev/null | awk '{print strtonum($1)}')
        local size=$(cat /sys/devices/obmm/${mem_id}/size 2>/dev/null | awk '{print strtonum($1)}')
        local pa_end=$(($pa + $size))
        mem_locations=(${mem_locations[@]} $pa $pa_end)
    done
    __smap_command_get_rect "smap smap_migrate_remote_numa $src_nid $dest_nid $count ${mem_locations[@]}"
}

function smap_add_process_tracking()
{
    local pid_str=$1
    local pid_time=$2
    local length=$3
    local scan_type=$4
    __smap_command_get_rect "smap smap_add_process_tracking $pid_str $pid_time $length $scan_type"
}

function smap_remove_process_tracking()
{
    local pid_str=$1
    local length=$2
    local flag=$3
    __smap_command_get_rect "smap smap_remove_process_tracking $pid_str $length $flag"
}

function smap_query_process_config()
{
    local nid=$1
    local flag=$2
    local in_len=$3
    local out_len=$4
    __smap_command_get_res "smap smap_query_process_config $nid $flag $in_len $out_len"
}

function smap_query_freq_info()
{
    local pid=$1
    __smap_command_get_res "smap smap_query_freq_info $pid"
}
