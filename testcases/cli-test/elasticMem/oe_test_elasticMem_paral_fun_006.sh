#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_paral_fun.006 - nr_cpus 超 node CPU 数启动失败
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # 设置过大的 nr_cpus
    em_write_paral_config "[test]" 99999
    em_mark_log
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    # nr_cpus 超过 node CPU 数应被拒绝：日志含 "exceeds cpu count" 且初始化失败
    em_assert_log_contains "exceeds cpu count"
    CHECK_RESULT $? 0 0 "log missing exceeds cpu count error"
    em_assert_log_contains "workflow init failed"
    CHECK_RESULT $? 0 0 "service should fail init with excessive nr_cpus"

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
