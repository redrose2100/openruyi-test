#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_common_fun.004 - 验证命令行参数指定配置文件路径
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_stop_service
    rm -rf /tmp/em_test
    mkdir -p /tmp/em_test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 0

    cat > /tmp/em_test/custom.ini << EOF
policy = light
log_level = debug
log_file = /tmp/em_test/elasticMem.log
whitelist = []
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF

    /usr/bin/elasticMem /tmp/em_test/custom.ini &
    em_track_pid $!
    local PID=$!
    sleep 5

    ps -p $PID > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "elasticMem not running with custom config"

    [ -f /tmp/em_test/elasticMem.log ]
    CHECK_RESULT $? 0 0 "custom log file not created"

    grep -q "Config loaded successfully" /tmp/em_test/elasticMem.log 2>/dev/null
    CHECK_RESULT $? 0 0 "config not loaded from custom path"

    em_safe_kill $PID
    sleep 3

    ps -p $PID > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "SIGTERM graceful exit failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/em_test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
