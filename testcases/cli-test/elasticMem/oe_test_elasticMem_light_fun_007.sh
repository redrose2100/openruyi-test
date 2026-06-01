#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.007 - 低负载跳过 balance
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

    # debug 级别以查看 balance 决策日志
    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = debug
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 等待足够周期让 balance 评估
    sleep 30

    # 系统空闲时应显示 no need to balance
    em_assert_log_contains "system load is low" "1 min ago"
    CHECK_RESULT $? 0 0 "balance should be skipped when idle"

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
