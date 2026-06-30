#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.002 - CPU 负载均衡放置
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

    # NUMA0 高负载
    numactl --cpunodebind=0 --membind=0 stress-ng --cpu $(nproc --all) --timeout 120s &
    em_track_pid $!
    local HIGH_PID=$!
    em_track_pid $HIGH_PID
    sleep 10

    # 启动新进程
    bash -c "sleep 30" &
    em_track_pid $!
    local NEW_PID=$!
    em_track_pid $NEW_PID
    sleep 15

    # 检查新进程的 cgroup
    local cgroup_line
    cgroup_line=$(cat /proc/$NEW_PID/cgroup 2>/dev/null | grep cpuset)
    LOG_INFO "New PID $NEW_PID cgroup: $cgroup_line"
    echo "$cgroup_line" | grep -q 'em_node'
    CHECK_RESULT $? 0 0 "new process not assigned to em_node cgroup"

    em_safe_kill $HIGH_PID; em_safe_kill $NEW_PID
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
