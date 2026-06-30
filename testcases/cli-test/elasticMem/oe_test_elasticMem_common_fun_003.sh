#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_common_fun.003 - light 模式 whitelist 为空不过滤
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

    em_write_light_config "[]" "false"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 启动测试进程
    em_start_cpu_load "" 1 60
    local PID=$em_LAST_PID
    sleep 15

    # 等待调优周期后检查进程是否被分配 cgroup
    local found=0
    for cg in "$CGROUP_BASE"/em_node*/cgroup.procs; do
        [ -f "$cg" ] && grep -q "$PID" "$cg" 2>/dev/null && found=1 && break
    done
    [ "$found" -eq 1 ]
    CHECK_RESULT $? 0 0 "process not assigned to any cgroup"

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
