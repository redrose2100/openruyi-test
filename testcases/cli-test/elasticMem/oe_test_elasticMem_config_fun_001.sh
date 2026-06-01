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
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    # 确认配置文件中 policy=paral
    grep -q '^policy' "$CONFIG_PATH" 2>/dev/null && \
        sed -i 's/^policy.*/policy = paral/' "$CONFIG_PATH" || \
        em_write_paral_config
    grep '^policy' "$CONFIG_PATH"
    CHECK_RESULT $? 0 0 "policy not set to paral"

    # 启动服务
    em_start_service
    CHECK_RESULT $? 0 0 "elasticMem service start failed"

    # 检查状态
    systemctl status $SERVICE_NAME --no-pager -l | grep "active (running)"
    CHECK_RESULT $? 0 0 "service not active"

    # 检查日志
    em_assert_log_contains "policy: paral"
    CHECK_RESULT $? 0 0 "log missing policy: paral"
    em_assert_log_contains "ElasticMem service started"
    CHECK_RESULT $? 0 0 "log missing service started"

    # 确认进程存在
    ps aux | grep elasticMem | grep -v grep | grep -v mugen
    CHECK_RESULT $? 0 0 "elasticMem process not found"

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
