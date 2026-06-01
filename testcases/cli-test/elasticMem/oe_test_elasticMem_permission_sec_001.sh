#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_permission_sec.001 - 非 root 无法操作
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_backup_config
    em_stop_service
    useradd testuser 2>/dev/null || echo "user exists"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    em_write_paral_config "[__nonexist__]"
    em_start_service
    CHECK_RESULT $? 0 0 "elasticMem start failed"

    # testuser 尝试修改配置
    su - testuser -c "echo 'policy = paral' > $CONFIG_PATH" 2>&1
    local rc=$?
    [ "$rc" -ne 0 ]
    CHECK_RESULT $? 0 0 "non-root could modify config"

    # testuser 尝试启停服务
    su - testuser -c "systemctl stop $SERVICE_NAME" 2>&1
    CHECK_RESULT $? 1 0 "non-root could stop service"

    # testuser 尝试直接运行 elasticMem
    su - testuser -c "/usr/bin/elasticMem /etc/elasticMem.ini" 2>/dev/null &
    em_track_pid $!
    local PID=$!
    sleep 2
    ps -p $PID > /dev/null 2>&1 && ps aux | grep $PID | grep testuser
    em_safe_kill $PID

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    userdel -rf testuser 2>/dev/null
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
