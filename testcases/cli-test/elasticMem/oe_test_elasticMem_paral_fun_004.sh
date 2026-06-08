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
    rm "$LOG_FILE"
    LOG_INFO "Cleaned old log: $LOG_FILE"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    export 'PS4=[`date +"%m-%d %H:%M:%S"`]`basename $0`:$LINENO + '
    em_check_env || return 1

    # 使用 debug 日志以便统计
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = debug
log_file = $LOG_FILE
whitelist = [sleep]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    sleep 10
    # 快速创建 50 个短生命周期进程
    for i in $(seq 1 50); do
        sleep 30 &
        em_track_pid $!
	echo $!
    done
    wait
    sleep 30

for pid in $(grep -oP "ParalTune set pid\(\K\d+" /var/log/elasticMem/elasticMem.log)
do
    ps aux | grep -v grep | grep -w $pid
done
    # 统计绑核记录数
    local count
    count=$(grep -c "ParalTune set pid" "$LOG_FILE" 2>/dev/null || echo 0)
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
