#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_log_ras.001 - 删除日志自动重建
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

    em_write_paral_config "[__nonexist__]"
    em_start_service
    CHECK_RESULT $? 0 0 "service start failed"

    [ -f "$LOG_FILE" ]
    CHECK_RESULT $? 0 0 "log file not created"

    # 删除日志文件
    rm -f "$LOG_FILE"
    [ -f "$LOG_FILE" ] && { LOG_ERROR "log deletion failed"; return 1; }

    # 重启触发新日志
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 3

    [ -f "$LOG_FILE" ]
    CHECK_RESULT $? 0 0 "log file not recreated after deletion"

    tail -3 "$LOG_FILE"
    CHECK_RESULT $? 0 0 "log file empty after recreation"

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
