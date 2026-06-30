#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.006 - sample_interval 和 sample_count 影响调优频率
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

    em_write_light_config "[]" "false" 200 5
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 确认日志中的参数
    em_assert_log_contains "PMU interval"
    CHECK_RESULT $? 0 0 "PMU interval not logged"
    em_assert_log_contains "tune every 5 samples"
    CHECK_RESULT $? 0 0 "tune every not logged correctly"

    # 修改参数
    sed -i 's/sample_interval = 200/sample_interval = 500/' "$CONFIG_PATH"
    sed -i 's/sample_count = 5/sample_count = 2/' "$CONFIG_PATH"
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 2

    em_assert_log_contains "PMU interval 500 ms"
    CHECK_RESULT $? 0 0 "interval not updated to 500"
    em_assert_log_contains "tune every 2 samples"
    CHECK_RESULT $? 0 0 "sample_count not updated to 2"

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
