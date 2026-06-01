#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_log_ras.001 - logrotate 日志轮转
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_dnf_install logrotate
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    # debug 级别产生大量日志
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = debug
log_file = $LOG_FILE
whitelist = [__nonexist__]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "service start failed"

    # 写入 logrotate 配置
    cat > /etc/logrotate.d/elasticMem << EOFLOG
$LOG_FILE {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    copytruncate
    dateext
    dateformat -%Y%m%d
}
EOFLOG

    [ -f "$LOG_FILE" ]
    CHECK_RESULT $? 0 0 "log file not found"

    # 触发轮转
    logrotate -vf /etc/logrotate.d/elasticMem 2>/dev/null
    sleep 2

    # 检查轮转结果
    ls -la "$LOG_DIR"/elasticMem.log* 2>/dev/null
    CHECK_RESULT $? 0 0 "log files listing failed"

    # 服务应仍在运行
    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "service stopped during logrotate"

    rm -f /etc/logrotate.d/elasticMem "$LOG_DIR"/elasticMem.log-*
    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    rm -f /etc/logrotate.d/elasticMem "$LOG_DIR"/elasticMem.log-*
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
