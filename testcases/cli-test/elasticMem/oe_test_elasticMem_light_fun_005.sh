#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.005 - memory_migration=false 不迁移内存
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_stress_ng || return 1
    em_require_numactl || return 1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 0

    em_write_light_config "[]" "false"
    > "$LOG_FILE"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    numactl --cpunodebind=0 --membind=0 stress-ng --vm 1 --vm-bytes 1G --vm-keep --timeout 180s &
    em_track_pid $!
    local PID=$!
    sleep 20

    local mem_before
    mem_before=$(numastat -p $PID 2>/dev/null | awk '/^[0-9]/{print $2}' | head -2)
    LOG_INFO "mem before: $mem_before"

    sleep 30

    local mem_after
    mem_after=$(numastat -p $PID 2>/dev/null | awk '/^[0-9]/{print $2}' | head -2)
    LOG_INFO "mem after: $mem_after"

    if grep -q "MigratePages" "$LOG_FILE" 2>/dev/null; then
        CHECK_RESULT 1 0 0 "migration log found when migration=false"
    fi

    em_safe_kill $PID
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
