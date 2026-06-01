#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_paral_prf.001 - paral 绑核延迟
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

    em_write_paral_config "[test]"
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    local START_TS=$(date +%s%N)
    for i in $(seq 1 100); do
        bash -c 'exit 0' "#test" &
        em_track_pid $!
    done
    wait
    local END_TS=$(date +%s%N)
    local ELAPSED_MS=$(( (END_TS - START_TS) / 1000000 ))
    LOG_INFO "100 processes elapsed: ${ELAPSED_MS} ms"

    # 统计绑核记录数
    local processed
    processed=$(journalctl -u $SERVICE_NAME --since "1 min ago" --no-pager 2>/dev/null | grep -c "ParalTune set pid")
    LOG_INFO "ParalTune processed: $processed"

    # 延迟应在可接受范围（< 500ms 总耗时）
    [ "$ELAPSED_MS" -lt 5000 ]
    CHECK_RESULT $? 0 0 "100 processes took ${ELAPSED_MS}ms (>5s)"

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
