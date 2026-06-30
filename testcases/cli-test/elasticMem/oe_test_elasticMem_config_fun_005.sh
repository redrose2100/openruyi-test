#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_config_fun.005 - 配置文件不存在时启动失败
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

    # 删除配置
    rm -f "$CONFIG_PATH"
    [ -f "$CONFIG_PATH" ] && { LOG_ERROR "config still exists"; return 1; }

    # elasticMem 无代码级默认值：缺少配置文件时加载失败、初始化失败
    em_mark_log
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    em_assert_log_contains "Failed to load config"
    CHECK_RESULT $? 0 0 "log missing 'Failed to load config'"

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
