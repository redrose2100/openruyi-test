#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_config_fun.003 - 验证 policy 非法值启动失败
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

    # 设置非法 policy
    cat > "$CONFIG_PATH" << EOF
policy = auto
log_level = info
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF

    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 2

    # 服务应为 failed 或 inactive
    systemctl is-active $SERVICE_NAME --quiet && LOG_ERROR "service unexpectedly active"
    CHECK_RESULT $? 1 0 "service should not be active with invalid policy"

    em_assert_log_contains "Invalid policy"
    CHECK_RESULT $? 0 0 "log missing Invalid policy error"

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
