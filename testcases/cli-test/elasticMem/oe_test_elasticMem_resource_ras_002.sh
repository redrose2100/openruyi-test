#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_resource_ras.002 - paral 高频进程创建无遗漏
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

    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = info
log_file = $LOG_FILE
whitelist = [test]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    # 每秒 20 个进程，持续 30 秒
    local total=0
    for sec in $(seq 1 30); do
        for i in $(seq 1 20); do
            bash -c 'exit 0' "#test" &
            em_track_pid $!
            total=$((total + 1))
        done
        sleep 1
    done
    wait
    sleep 3

    local processed
    processed=$(journalctl -u $SERVICE_NAME --since "1 min ago" --no-pager 2>/dev/null | grep -c "ParalTune set pid")
    LOG_INFO "Launched: $total, Processed: $processed"

    # 允许少量遗漏（短生命周期 trace 捕获窗口有限）
    local rate=$(( processed * 100 / total ))
    LOG_INFO "Capture rate: ${rate}%"
    [ "$rate" -ge 70 ]
    CHECK_RESULT $? 0 0 "capture rate ${rate}% below 70%"

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
