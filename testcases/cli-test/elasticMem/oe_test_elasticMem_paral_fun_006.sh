#!/usr/bin/bash
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

    em_write_paral_config "[test]" 99999
    > "$LOG_FILE"
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    em_assert_log_contains "exceeds cpu count\|nrCpus.*exceed\|Invalid nr_cpus\|nr_cpus.*invalid\|too large"
    CHECK_RESULT $? 0 0 "log missing exceeds cpu count error"

    em_assert_log_contains "workflow init failed\|init failed\|exited"
    CHECK_RESULT $? 0 0 "log missing init failure"

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
