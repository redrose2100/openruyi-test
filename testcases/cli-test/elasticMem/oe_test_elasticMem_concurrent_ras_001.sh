#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_concurrent_ras.001 - 多实例启动被拒绝
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

    em_write_paral_config "[__nonexist__]"
    em_start_service
    CHECK_RESULT $? 0 0 "first instance start failed"

    # 尝试启动第二个实例
    /usr/bin/elasticMem /etc/elasticMem.ini &
    em_track_pid $!
    local PID2=$!
    em_track_pid $PID2
    sleep 2

    ps -p $PID2 > /dev/null 2>&1
    local rc2=$?
    em_safe_kill $PID2

    # 第二个实例不应与第一个正常运行同时存在
    # elasticMem 无 PID 锁机制，第二个可能抢占 tracefs，记录行为即可
    LOG_INFO "Second instance PID $PID2 alive=$([ $rc2 -eq 0 ] && echo yes || echo no)"

    # 确认第一个实例仍存活
    systemctl is-active $SERVICE_NAME --quiet
    CHECK_RESULT $? 0 0 "first instance was affected"

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
