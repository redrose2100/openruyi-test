#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_common_fun.001 - 验证 log_level 各级别生效
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

    # whitelist 必须非空，否则 paral 模式初始化失败（"whitelist is empty!"）
    for level in debug info warn error; do
        LOG_INFO "Testing log_level=$level"
        cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = $level
log_file = $LOG_FILE
whitelist = [test]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
        em_start_service
        CHECK_RESULT $? 0 0 "service failed with log_level=$level"

        # elasticMem 日志写文件（非 journal），用标记窗口统计本级别日志行数
        local log_count
        log_count=$(em_log_count "")
        LOG_INFO "log_level=$level: $log_count lines"
        [ "$log_count" -gt 0 ]
        CHECK_RESULT $? 0 0 "no log output for level=$level"
    done

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
