#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_process_ras.001 - SIGTERM 优雅退出
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

    # === paral 模式 ===
    em_write_paral_config "[test]"
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    local pid=$(em_get_service_pid)
    em_safe_kill $pid
    sleep 3

    ps -p $pid > /dev/null 2>&1 && LOG_ERROR "paral process still alive after SIGTERM"
    CHECK_RESULT $? 1 0 "paral SIGTERM graceful exit failed"

    # 检查 tracefs 清理
    local enable_val
    enable_val=$(cat /sys/kernel/debug/tracing/events/sched/sched_process_exec/enable 2>/dev/null)
    LOG_INFO "trace enable after exit: $enable_val"
    [ "$enable_val" != "1" ]
    CHECK_RESULT $? 0 0 "trace event not disabled after exit"

    # === light 模式 ===
    em_write_light_config
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    pid=$(em_get_service_pid)
    em_safe_kill $pid
    sleep 3

    ps -p $pid > /dev/null 2>&1 && LOG_ERROR "light process still alive after SIGTERM"
    CHECK_RESULT $? 1 0 "light SIGTERM graceful exit failed"

    # 检查 cgroup 是否被清理
    local cg_left
    cg_left=$(ls "$CGROUP_BASE"/ 2>/dev/null | grep -c '^em_node')
    LOG_INFO "Remaining em_node cgroups: $cg_left"

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
