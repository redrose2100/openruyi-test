#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.003 - memory_migration=true 内存迁移
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

    em_write_light_config "[]" "true"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # NUMA0 上启动 1GB 内存进程
    numactl --cpunodebind=0 --membind=0 stress-ng --vm 1 --vm-bytes 1G --vm-keep --timeout 180s &
    em_track_pid $!
    local PID=$!
    sleep 20

    # 记录迁移前 mem 分布
    local numa_before
    numa_before=$(numastat -p $PID 2>/dev/null | grep -E '^[0-9]')
    LOG_INFO "NUMA before: $numa_before"

    # 等待迁移
    sleep 30

    local numa_after
    numa_after=$(numastat -p $PID 2>/dev/null | grep -E '^[0-9]')
    LOG_INFO "NUMA after: $numa_after"

    # 检查进程是否被分配到 cgroup
    cat /proc/$PID/cgroup 2>/dev/null | grep -q 'em_node'
    CHECK_RESULT $? 0 0 "process not in em_node cgroup"

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
