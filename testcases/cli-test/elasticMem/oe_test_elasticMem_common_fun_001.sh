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

    for level in debug info warn error; do
        LOG_INFO "Testing log_level=$level"
        cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = $level
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
        systemctl restart $SERVICE_NAME 2>/dev/null
        sleep 2

        systemctl is-active $SERVICE_NAME --quiet
        CHECK_RESULT $? 0 0 "service failed with log_level=$level"

        local log_count
        log_count=$(journalctl -u $SERVICE_NAME --since "5 sec ago" --no-pager 2>/dev/null | wc -l)
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
