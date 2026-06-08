#!/usr/bin/bash
source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_numactl || return 1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 0

    em_write_paral_config
    > "$LOG_FILE"
    em_start_service_for_paral
    CHECK_RESULT $? 0 0 "paral mode start failed"

    em_assert_log_contains "ParalTune activated"
    CHECK_RESULT $? 0 0 "paral not activated"

    sed -i 's/^policy.*/policy = light/' "$CONFIG_PATH"
    sleep 15

    grep -q "Executing light tune\|light tune" "$LOG_FILE" 2>/dev/null
    CHECK_RESULT $? 1 0 "light tune appeared without restart"

    > "$LOG_FILE"
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 5

    em_assert_log_contains "Executing light tune"
    CHECK_RESULT $? 0 0 "light tune not started after restart"

    [ -d "$CGROUP_BASE/em_node0" ]
    CHECK_RESULT $? 0 0 "em_node0 cgroup not created after switch"

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
