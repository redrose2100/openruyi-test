#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_paral_fun.003 - 验证进程退出后槽位复用
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

    # 启动 A
    bash -c "sleep 30 #test" &
    em_track_pid $!
    local A=$!
    sleep 2
    local cpuA=$(LC_ALL=C taskset -p $A 2>/dev/null | awk '{print $NF}')
    LOG_INFO "A (PID $A): affinity=$cpuA"

    # 启动 B
    bash -c "sleep 30 #test" &
    em_track_pid $!
    local B=$!
    sleep 2
    local cpuB=$(LC_ALL=C taskset -p $B 2>/dev/null | awk '{print $NF}')
    LOG_INFO "B (PID $B): affinity=$cpuB"

    # 结束 A，启动 C
    em_safe_kill $A
    sleep 2
    bash -c "sleep 30 #test" &
    em_track_pid $!
    local C=$!
    sleep 2
    local cpuC=$(LC_ALL=C taskset -p $C 2>/dev/null | awk '{print $NF}')
    LOG_INFO "C (PID $C): affinity=$cpuC"

    # C 应该分配到不同于 B 的 NUMA 或下一个 cluster
    [ "$cpuC" != "$cpuB" ]
    CHECK_RESULT $? 0 0 "C got same affinity as B, slot not rotated"

    em_safe_kill $B; em_safe_kill $C
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
