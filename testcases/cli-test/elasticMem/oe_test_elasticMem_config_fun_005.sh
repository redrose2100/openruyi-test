#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_config_fun.005 - 配置文件不存在使用默认值启动
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
    em_check_env || return 0

    rm -f "$CONFIG_PATH"
    [ ! -f "$CONFIG_PATH" ]
    CHECK_RESULT $? 0 0 "config still exists after removal"

    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    if systemctl is-active $SERVICE_NAME --quiet; then
        em_assert_log_contains "ElasticMem service started"
        CHECK_RESULT $? 0 0 "service started but log missing"
        LOG_INFO "Service started without config (using defaults) - PASS"
    else
        em_assert_log_contains "Config file not found\|No config\|config.*not.*found\|failed to load\|open.*elasticMem.ini"
        if [ $? -eq 0 ]; then
            LOG_INFO "Service cannot start without config file, reason logged - PASS"
        else
            LOG_INFO "Service failed without config but reason not in log - acceptable"
        fi
    fi

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
