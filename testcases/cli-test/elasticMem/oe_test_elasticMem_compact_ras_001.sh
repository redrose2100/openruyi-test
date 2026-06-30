#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_compact_ras.001 - compact_memory 交互
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_stress_ng
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    em_write_light_config "[]" "true"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 碎片化负载
    stress-ng --vm 4 --vm-bytes 256M --vm-hang 1 --timeout 180s &
    em_track_pid $!
    local STRESS_PID=$!
    em_track_pid $STRESS_PID
    sleep 10

    # 触发 compact_memory 3 次
    for i in 1 2 3; do
        echo 1 > /proc/sys/vm/compact_memory
        sleep 5
        systemctl is-active $SERVICE_NAME --quiet
        CHECK_RESULT $? 0 0 "service died after compact_memory #$i"
        LOG_INFO "compact_memory #$i: service alive"
    done

    em_safe_kill $STRESS_PID
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
