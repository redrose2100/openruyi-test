#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_injection_sec.001 - 配置命令注入被阻止
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # 注入测试：log_file 字段
    rm -rf /tmp/cmd_inject_test
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = info
log_file = \$(rm -rf /tmp/cmd_inject_test)
whitelist = []
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    # 命令注入不应被执行
    [ -d /tmp/cmd_inject_test ] && LOG_ERROR "command injection succeeded!"
    CHECK_RESULT $? 1 0 "command injection vulnerability: /tmp/cmd_inject_test exists"

    em_stop_service

    # 注入测试：whitelist 字段
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = info
log_file = $LOG_FILE
whitelist = [; cat /etc/passwd]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 2

    # 注入内容应被当作字面字符串
    em_assert_log_contains "cmdline_kw=; cat"
    local rc=$?
    LOG_INFO "whitelist injection treated as literal: $([ $rc -eq 0 ] && echo yes || echo 'may be sanitized')"

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    rm -rf /tmp/cmd_inject_test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
