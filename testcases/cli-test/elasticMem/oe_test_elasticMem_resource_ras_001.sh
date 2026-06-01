#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_resource_ras.001 - 高 CPU 压力下自身底噪 < 10%
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    em_require_stress_ng
    em_require_bc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = error
log_file = $LOG_FILE
whitelist = []
comm_whitelist = []
memory_migration = false
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    local EM_PID=$(em_get_service_pid)
    [ -n "$EM_PID" ]
    CHECK_RESULT $? 0 0 "cannot get elasticMem PID"

    # 全 CPU 压力
    stress-ng --cpu $(nproc) --timeout 120s &
    em_track_pid $!
    local STRESS_PID=$!
    em_track_pid $STRESS_PID
    sleep 10

    # 采集 elasticMem CPU（5 个样本）
    local total_cpu=0 count=0
    for i in $(seq 1 5); do
        local cpu
        cpu=$(ps -p $EM_PID -o %cpu --no-headers 2>/dev/null | tr -d ' ')
        [ -n "$cpu" ] && { total_cpu=$(echo "$total_cpu + $cpu" | bc); count=$((count + 1)); }
        sleep 10
    done

    if [ "$count" -gt 0 ]; then
        local avg_cpu=$(echo "scale=1; $total_cpu / $count" | bc)
        LOG_INFO "elasticMem avg CPU: ${avg_cpu}%"
        [ "$(echo "$avg_cpu < 10" | bc)" -eq 1 ]
        CHECK_RESULT $? 0 0 "CPU overhead ${avg_cpu}% exceeds 10%"
    fi

    em_safe_kill $STRESS_PID
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
