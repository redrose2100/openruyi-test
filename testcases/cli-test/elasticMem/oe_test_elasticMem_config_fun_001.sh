#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_config_fun.001 - 验证默认 policy=paral 服务启动
# #############################################

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

    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = debug
log_file = $LOG_FILE
whitelist = [bash]
comm_whitelist = [bash]
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    grep '^policy' "$CONFIG_PATH"
    CHECK_RESULT $? 0 0 "policy not set to paral"

    > "$LOG_FILE"
    em_start_service_for_paral
    CHECK_RESULT $? 0 0 "elasticMem service start failed"

    em_assert_log_contains "policy: paral"
    CHECK_RESULT $? 0 0 "log missing policy: paral"
    em_assert_log_contains "ElasticMem service started"
    CHECK_RESULT $? 0 0 "log missing service started"
    em_assert_log_contains "ParalTune"
    CHECK_RESULT $? 0 0 "ParalTune not in log"

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
