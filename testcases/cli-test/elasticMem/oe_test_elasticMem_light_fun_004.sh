#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.004 - 已绑定非 em_node cgroup 的进程被过滤
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    em_write_light_config "[]" "false"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 手动创建非 em_node cgroup
    mkdir -p "$CGROUP_BASE/manual_test"
    echo "0-3" > "$CGROUP_BASE/manual_test/cpuset.cpus"
    echo "0" > "$CGROUP_BASE/manual_test/cpuset.mems"

    # 启动进程并绑定到 manual cgroup
    bash -c "sleep 30" &
    em_track_pid $!
    local PID=$!
    echo $PID > "$CGROUP_BASE/manual_test/cgroup.procs" 2>/dev/null
    sleep 2

    # 验证当前 cgroup
    cat /proc/$PID/cgroup 2>/dev/null | grep -q 'manual_test'
    CHECK_RESULT $? 0 0 "process not bound to manual_test"

    # 等待调优周期
    sleep 20

    # 验证仍保持在 manual_test
    cat /proc/$PID/cgroup 2>/dev/null | grep -q 'manual_test'
    CHECK_RESULT $? 0 0 "process was moved from manual_test cgroup"

    em_safe_kill $PID
    rmdir "$CGROUP_BASE/manual_test" 2>/dev/null
    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    rmdir "$CGROUP_BASE/manual_test" 2>/dev/null
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
