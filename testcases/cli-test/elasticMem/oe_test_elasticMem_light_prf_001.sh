#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_prf.001 - light 迁移耗时
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_stress_ng
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = debug
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # NUMA0 启动 1GB 内存进程
    numactl --cpunodebind=0 --membind=0 stress-ng --vm 1 --vm-bytes 1G --vm-keep --timeout 180s &
    em_track_pid $!
    local PID=$!
    sleep 30

    # 等待 light 迁移
    sleep 30

    # 检查日志中的迁移耗时
    local cost_log
    cost_log=$(journalctl -u $SERVICE_NAME --since "2 min ago" --no-pager 2>/dev/null | grep -i "cost" | head -5)
    LOG_INFO "Migration cost log: $cost_log"

    # 记录迁移后 mem 分布
    numastat -p $PID 2>/dev/null | head -5
    CHECK_RESULT $? 0 0 "numastat after migration failed"

    em_safe_kill $PID
    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
