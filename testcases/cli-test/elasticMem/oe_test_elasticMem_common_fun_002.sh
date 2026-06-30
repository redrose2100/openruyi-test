#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_common_fun.002 - 验证 paral whitelist 只取第一个
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

    # whitelist 含多个关键字，paral 只读第一个
    em_write_paral_config "[--executor-id, spark]"
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    # 确认只激活第一个关键字
    em_assert_log_contains "cmdline_kw=--executor-id"
    CHECK_RESULT $? 0 0 "first keyword not activated"

    # 启动不含 --executor-id 的进程
    bash -c "sleep 30" &
    em_track_pid $!
    local PID1=$!
    em_track_pid $PID1
    sleep 2

    # 检查未被绑核（affinity 应为全部 CPU）
    local aff1
    aff1=$(LC_ALL=C LC_ALL=C taskset -p $PID1 2>/dev/null | awk '{print $NF}')
    LOG_INFO "PID $PID1 affinity: $aff1"

    # 启动含 --executor-id 的进程
    bash -c "sleep 30 #--executor-id test" &
    em_track_pid $!
    local PID2=$!
    em_track_pid $PID2
    sleep 2

    local aff2
    aff2=$(LC_ALL=C LC_ALL=C taskset -p $PID2 2>/dev/null | awk '{print $NF}')
    LOG_INFO "PID $PID2 affinity (should be restricted): $aff2"

    # 含关键字的进程应被绑核（affinity 不同于全部 CPU）
    [ "$aff2" != "$(cat /sys/devices/system/cpu/present)" ]
    CHECK_RESULT $? 0 0 "process not bound by paral"

    em_safe_kill $PID1; em_safe_kill $PID2
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
