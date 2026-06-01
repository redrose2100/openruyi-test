#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_longrun_ras.001 - 7x24h 长稳无泄漏 (skeleton)
# @Note    : 此用例需手动执行和长期监控，默认跳过
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_stress_ng
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    # 长稳测试需 >= 144h (6天 x 24h)，此骨架仅展示监控方式
    local DURATION_HOURS=${1:-168}
    LOG_WARN "Long run test requires ${DURATION_HOURS}h. Hook into scheduling system for production run."

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = warn
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

    local EM_PID=$(em_get_service_pid)

    # 循环负载
    (
        while true; do
            stress-ng --cpu 2 --vm 2 --vm-bytes 512M --timeout 30s 2>/dev/null
            sleep 5
        done
    ) &
    em_track_pid $!
    local LOOP_PID=$!
    em_track_pid $LOOP_PID

    # 初始快照
    local rss0=$(awk '/VmRSS/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    local thr0=$(awk '/Threads/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    LOG_INFO "T+0: RSS=${rss0}kB Threads=${thr0}"

    # 短期验证（60s 采样检测明显泄漏趋势）
    sleep 60
    local rss1=$(awk '/VmRSS/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    local thr1=$(awk '/Threads/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    LOG_INFO "T+60s: RSS=${rss1}kB Threads=${thr1}"

    # 短期 RSS 增长 < 50% 初始值
    if [ -n "$rss0" ] && [ "$rss0" -gt 0 ]; then
        local growth=$(( (rss1 - rss0) * 100 / rss0 ))
        LOG_INFO "RSS growth: ${growth}%"
        [ "$growth" -lt 50 ]
        CHECK_RESULT $? 0 0 "RSS growth ${growth}% in 60s, possible leak"
    fi

    em_safe_kill $LOOP_PID
    LOG_INFO "For full 7-day test, schedule via cron/systemd timer"

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
