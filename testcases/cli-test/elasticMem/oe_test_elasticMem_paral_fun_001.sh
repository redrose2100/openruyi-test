#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_paral_fun.001 - 验证 paral 进程按 NUMA 轮询分配
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    em_write_paral_config "[test]"
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    local N=$(em_get_numa_count)
    M=$((2 * N))

    # 批量启动进程
    pids=()
    for i in $(seq 1 $M); do
        bash -c "sleep 30 #test" &
        em_track_pid $!
        pids+=($!)
    done
    sleep 3

    # 统计各 NUMA 分布
    declare -A node_count
    for pid in ${pids[@]}; do
        local cpu
        cpu=$(LC_ALL=C taskset -p $pid 2>/dev/null | awk -F': ' '{print $2}' | cut -d',' -f1 | cut -d'-' -f1)
        [ -z "$cpu" ] && continue
        local node
        node=$(ls -d /sys/devices/system/cpu/cpu${cpu}/node* 2>/dev/null | head -1 | grep -oP 'node\K\d+')
        [ -z "$node" ] && node="unknown"
        node_count[$node]=$((node_count[$node] + 1))
        LOG_INFO "PID $pid -> CPU $cpu -> Node $node"
    done

    # 验证均匀分布（差值 ≤ 1）
    local min_count=999
    local max_count=0
    for nd in $(seq 0 $((N-1))); do
        local cnt=${node_count[$nd]:-0}
        [ "$cnt" -lt "$min_count" ] && min_count=$cnt
        [ "$cnt" -gt "$max_count" ] && max_count=$cnt
    done
    LOG_INFO "min=$min_count max=$max_count"
    [ $((max_count - min_count)) -le 1 ]
    CHECK_RESULT $? 0 0 "NUMA distribution not uniform"

    # 清理
    for p in ${pids[@]}; do em_safe_kill $p; done

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
