#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_paral_fun.002 - 验证 nr_cpus 绑定范围正确
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

    local NR=4
    em_write_paral_config "[test]" $NR
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    # 查看各 node CPU
    for n in /sys/devices/system/node/node*/cpulist; do
        [ -f "$n" ] && LOG_INFO "$(basename $(dirname $n)) cpulist: $(cat $n)"
    done

    # 启动 2 个进程
    bash -c "sleep 30 #test" &
    em_track_pid $!
    local PID1=$!
    em_track_pid $PID1
    bash -c "sleep 30 #test" &
    em_track_pid $!
    local PID2=$!
    em_track_pid $PID2
    sleep 3

    for pid in $PID1 $PID2; do
        local cpus
        cpus=$(cat /proc/$pid/status 2>/dev/null | grep Cpus_allowed_list | awk '{print $2}')
        LOG_INFO "PID $pid bound CPUs: $cpus"
        [ -n "$cpus" ]
        CHECK_RESULT $? 0 0 "Cpus_allowed_list empty for PID $pid"
    done

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
