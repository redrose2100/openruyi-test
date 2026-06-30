#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_paral_fun.004 - 短生命周期进程无遗漏
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

    # 使用 debug 日志以便统计
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

    # 创建 50 个短生命周期进程（bash 保持存活且 cmdline 含 #test，确保被捕获并绑核；
    # 用 "sleep 5 & wait" 避免 bash exec 到 sleep 导致 cmdline 丢失 #test 关键字）
    for i in $(seq 1 50); do
        bash -c 'sleep 5 & wait' "#test" &
        em_track_pid $!
    done
    wait
    sleep 3

    # 统计绑核记录数（elasticMem 日志写文件，从标记窗口统计）
    local count
    count=$(em_log_count "ParalTune set pid")
    LOG_INFO "ParalTune set pid count: $count"
    [ "$count" -ge 45 ]
    CHECK_RESULT $? 0 0 "capture rate too low: $count/50"

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
