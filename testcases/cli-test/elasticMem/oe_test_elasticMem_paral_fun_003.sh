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
    em_check_env || return 0

    em_write_paral_config "[test]"
    > "$LOG_FILE"
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    local wait=0
    while [ $wait -lt 30 ]; do
        [ -f "$LOG_FILE" ] && grep -q "Executing paral tune" "$LOG_FILE" 2>/dev/null && break
        sleep 1
        wait=$((wait + 1))
    done
    [ $wait -lt 30 ]
    CHECK_RESULT $? 0 0 "paral tune not initialized within 30s"
    sleep 1

    bash -c "sleep 30 #test" &
    em_track_pid $!
    local A=$!
    sleep 3
    local cpuA=$(LC_ALL=C taskset -p $A 2>/dev/null | awk '{print $NF}')
    LOG_INFO "A (PID $A): affinity=$cpuA"

    bash -c "sleep 30 #test" &
    em_track_pid $!
    local B=$!
    sleep 3
    local cpuB=$(LC_ALL=C taskset -p $B 2>/dev/null | awk '{print $NF}')
    LOG_INFO "B (PID $B): affinity=$cpuB"

    [ "$cpuA" != "$cpuB" ]
    CHECK_RESULT $? 0 0 "A and B got same affinity, slot not rotating"

    em_safe_kill $A
    sleep 3
    bash -c "sleep 30 #test" &
    em_track_pid $!
    local C=$!
    sleep 3
    local cpuC=$(LC_ALL=C taskset -p $C 2>/dev/null | awk '{print $NF}')
    LOG_INFO "C (PID $C): affinity=$cpuC"

    [ "$cpuC" != "$cpuB" ]
    CHECK_RESULT $? 0 0 "C got same affinity as B, slot not rotated after A exited"

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
