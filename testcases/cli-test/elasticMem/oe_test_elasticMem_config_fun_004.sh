#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_config_fun.004 - 验证 paral↔light 切换需重启
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

    # 启动 paral 模式
    em_write_paral_config
    em_start_service
    CHECK_RESULT $? 0 0 "paral mode start failed"

    # 确认 paral 运行
    em_assert_log_contains "ParalTune activated"
    CHECK_RESULT $? 0 0 "paral not activated"

    # 修改配置为 light 但不重启
    sed -i 's/^policy.*/policy = light/' "$CONFIG_PATH"
    sleep 15

    # 确认 light 日志未出现（无热加载）
    em_assert_not_log_contains "light tune" "20 sec ago"
    CHECK_RESULT $? 0 0 "light tune appeared without restart"

    # 重启服务
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 3

    # 确认切换到 light
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
