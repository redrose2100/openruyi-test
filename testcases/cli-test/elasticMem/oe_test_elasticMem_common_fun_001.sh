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

    local debug_cnt info_cnt warn_cnt

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
    > "$LOG_FILE"
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 5
    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "service failed with log_level=debug"
    debug_cnt=$(grep -c '\[DEBUG\]' "$LOG_FILE" 2>/dev/null)
    debug_cnt=${debug_cnt:-0}
    LOG_INFO "log_level=debug: $debug_cnt DEBUG lines"
    [ "$debug_cnt" -gt 0 ]
    CHECK_RESULT $? 0 0 "no DEBUG output when log_level=debug"

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = info
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    > "$LOG_FILE"
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 5
    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "service failed with log_level=info"
    debug_cnt=$(grep -c '\[DEBUG\]' "$LOG_FILE" 2>/dev/null)
    debug_cnt=${debug_cnt:-0}
    LOG_INFO "log_level=info: $debug_cnt DEBUG lines (should be 0)"
    [ "$debug_cnt" -eq 0 ]
    CHECK_RESULT $? 0 0 "DEBUG lines not filtered when log_level=info"
    info_cnt=$(grep -c '\[INFO\]' "$LOG_FILE" 2>/dev/null)
    info_cnt=${info_cnt:-0}
    LOG_INFO "log_level=info: $info_cnt INFO lines"
    [ "$info_cnt" -gt 0 ]
    CHECK_RESULT $? 0 0 "no INFO output when log_level=info"

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = warn
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    > "$LOG_FILE"
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 5
    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "service failed with log_level=warn"
    debug_cnt=$(grep -c '\[DEBUG\]' "$LOG_FILE" 2>/dev/null)
    debug_cnt=${debug_cnt:-0}
    LOG_INFO "log_level=warn: $debug_cnt DEBUG lines (should be 0)"
    [ "$debug_cnt" -eq 0 ]
    CHECK_RESULT $? 0 0 "DEBUG lines not filtered when log_level=warn"

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = error
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    > "$LOG_FILE"
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 5
    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "service failed with log_level=error"
    debug_cnt=$(grep -c '\[DEBUG\]' "$LOG_FILE" 2>/dev/null)
    debug_cnt=${debug_cnt:-0}
    LOG_INFO "log_level=error: $debug_cnt DEBUG lines (should be 0)"
    [ "$debug_cnt" -eq 0 ]
    CHECK_RESULT $? 0 0 "DEBUG lines not filtered when log_level=error"
    warn_cnt=$(grep -c '\[WARN\]' "$LOG_FILE" 2>/dev/null)
    warn_cnt=${warn_cnt:-0}
    LOG_INFO "log_level=error: $warn_cnt WARN lines (should be 0)"
    [ "$warn_cnt" -eq 0 ]
    CHECK_RESULT $? 0 0 "WARN lines not filtered when log_level=error"

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
