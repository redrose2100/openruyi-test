#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_config_fun.002 - 验证 policy=light 服务启动，cgroup 创建
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

    # 配置 light 模式
    em_write_light_config
    grep '^policy.*light' "$CONFIG_PATH"
    CHECK_RESULT $? 0 0 "policy not light"

    # 启动服务
    em_start_service
    CHECK_RESULT $? 0 0 "elasticMem start failed"

    systemctl status $SERVICE_NAME --no-pager -l | grep "active (running)"
    CHECK_RESULT $? 0 0 "service not active"

    # 检查日志
    em_assert_log_contains "Executing light tune"
    CHECK_RESULT $? 0 0 "log missing light tune"

    # 检查 cgroup 创建
    local N=$(em_get_numa_count)
    for i in $(seq 0 $((N-1))); do
        local dir="$CGROUP_BASE/em_node$i"
        [ -d "$dir" ] || { LOG_ERROR "cgroup em_node$i not found"; return 1; }
        [ -f "$dir/cpuset.cpus" ] || { LOG_ERROR "cpuset.cpus missing for em_node$i"; return 1; }
        [ -f "$dir/cpuset.mems" ] || { LOG_ERROR "cpuset.mems missing for em_node$i"; return 1; }
        LOG_INFO "em_node$i OK: cpus=$(cat $dir/cpuset.cpus) mems=$(cat $dir/cpuset.mems)"
    done

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
