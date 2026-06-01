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
    em_check_env || return 1

    # 删除配置
    rm -f "$CONFIG_PATH"
    [ -f "$CONFIG_PATH" ] && { LOG_ERROR "config still exists"; return 1; }

    # 启动服务（systemd 使用 /usr/bin/elasticMem，会找 /etc/elasticMem.ini 和默认值）
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 2

    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "service not active without config"

    # 确认使用默认值 (policy=paral, logLevel=info)
    em_assert_log_contains "ElasticMem service started"
    CHECK_RESULT $? 0 0 "service not started"

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
