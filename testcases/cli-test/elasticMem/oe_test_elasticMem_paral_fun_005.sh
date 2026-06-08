#!/usr/bin/bash
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

    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = debug
log_file = $LOG_FILE
whitelist = [test]
comm_whitelist = [bash]
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    > "$LOG_FILE"
    em_start_service_for_paral
    CHECK_RESULT $? 0 0 "paral start failed"

    em_assert_log_contains "comm=bash"
    CHECK_RESULT $? 0 0 "comm_whitelist not reflected in activation log"

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
