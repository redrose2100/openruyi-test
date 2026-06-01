#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_process_ras.002 - 快速 restart 无状态混乱
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

    em_write_light_config "[]" "false"
    local N=$(em_get_numa_count)

    for i in $(seq 1 10); do
        systemctl restart $SERVICE_NAME 2>/dev/null
        sleep 2
        systemctl is-active $SERVICE_NAME --quiet
        CHECK_RESULT $? 0 0 "restart $i failed"

        local actual=$(ls "$CGROUP_BASE/" 2>/dev/null | grep -c '^em_node')
        [ "$actual" -eq "$N" ]
        CHECK_RESULT $? 0 0 "cgroup count mismatch at restart $i: expected $N got $actual"
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
