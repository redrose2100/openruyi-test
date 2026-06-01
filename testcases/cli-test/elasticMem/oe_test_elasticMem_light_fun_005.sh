#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.005 - memory_migration=false 不迁移内存
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_stress_ng
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    em_write_light_config "[]" "false"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # NUMA0 上启动内存进程
    numactl --cpunodebind=0 --membind=0 stress-ng --vm 1 --vm-bytes 1G --vm-keep --timeout 180s &
    em_track_pid $!
    local PID=$!
    sleep 20

    # 记录初始内存分布
    local mem_before
    mem_before=$(numastat -p $PID 2>/dev/null | awk '/^[0-9]/{print $2}' | head -2)
    LOG_INFO "mem before: $mem_before"

    sleep 30

    local mem_after
    mem_after=$(numastat -p $PID 2>/dev/null | awk '/^[0-9]/{print $2}' | head -2)
    LOG_INFO "mem after: $mem_after"

    # migration=false 时日志不应有 migrate 记录
    em_assert_not_log_contains "MigratePages" "2 min ago"
    CHECK_RESULT $? 0 0 "migration log found when migration=false"

    em_safe_kill $PID
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
