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
    em_require_numactl || return 1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 0

    em_write_paral_config "[--executor-id, spark]"
    > "$LOG_FILE"
    em_start_service_for_paral
    CHECK_RESULT $? 0 0 "paral start failed"

    em_assert_log_contains "cmdline_kw=--executor-id"
    CHECK_RESULT $? 0 0 "first keyword not activated"

    bash -c "sleep 30" &
    em_track_pid $!
    local PID1=$!
    sleep 2

    local aff1
    aff1=$(em_get_cpu_affinity $PID1)
    LOG_INFO "PID $PID1 affinity: $aff1"

    bash -c "sleep 30 #--executor-id test" &
    em_track_pid $!
    local PID2=$!
    sleep 2

    local aff2
    aff2=$(em_get_cpu_affinity $PID2)
    LOG_INFO "PID $PID2 affinity (should be restricted): $aff2"

    local all_cpus
    all_cpus=$(cat /sys/devices/system/cpu/present)
    [ "$aff2" != "$all_cpus" ]
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
