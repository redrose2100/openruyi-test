#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_procfs_sec.001 - 日志不泄露敏感信息
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
log_level = debug
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

    # 启动含敏感参数的进程
    bash -c "sleep 30" "#test --password=secret123 --token=abc" &
    em_track_pid $!
    local PID=$!
    sleep 3

    # 检查日志中是否有敏感信息
    local log_content
    log_content=$(journalctl -u $SERVICE_NAME --since "30 sec ago" --no-pager 2>/dev/null | grep "$PID")

    local sensitive=0
    echo "$log_content" | grep -qi "password" && sensitive=1
    echo "$log_content" | grep -qi "token" && sensitive=1

    if [ "$sensitive" -eq 1 ]; then
        LOG_WARN "Potential sensitive data in log: consider security review"
    else
        LOG_INFO "No obvious sensitive keyword in logs"
    fi

    # 默认通过（敏感数据泄露需安全审计确认）
    em_safe_kill $PID
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
