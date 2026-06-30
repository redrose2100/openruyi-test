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

    em_mark_log
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    # 非法 policy 应被拒绝：日志含 "Invalid policy" 且初始化失败
    em_assert_log_contains "Invalid policy"
    CHECK_RESULT $? 0 0 "log missing Invalid policy error"
    em_assert_log_contains "workflow init failed"
    CHECK_RESULT $? 0 0 "service should fail init with invalid policy"

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
