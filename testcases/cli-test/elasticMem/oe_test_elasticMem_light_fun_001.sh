#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.001 - 验证 light 创建 em_node cgroup
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

    em_write_light_config
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    local N=$(em_get_numa_count)
    for i in $(seq 0 $((N-1))); do
        local dir="$CGROUP_BASE/em_node$i"
        [ -d "$dir" ]
        CHECK_RESULT $? 0 0 "cgroup em_node$i not found"
        local cpus=$(cat "$dir/cpuset.cpus" 2>/dev/null)
        local mems=$(cat "$dir/cpuset.mems" 2>/dev/null)
        LOG_INFO "em_node$i: cpus=$cpus mems=$mems"
        [ -n "$cpus" ]
        CHECK_RESULT $? 0 0 "cpuset.cpus empty for em_node$i"
        [ -n "$mems" ]
        CHECK_RESULT $? 0 0 "cpuset.mems empty for em_node$i"
    done

    # 验证仅有 em_node 命名，没有 elasticMem_ 命名
    local wrong
    wrong=$(ls "$CGROUP_BASE/" 2>/dev/null | grep -E '^elasticMem_' | wc -l)
    [ "$wrong" -eq 0 ]
    CHECK_RESULT $? 0 0 "found unexpected elasticMem_ cgroup naming"

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
