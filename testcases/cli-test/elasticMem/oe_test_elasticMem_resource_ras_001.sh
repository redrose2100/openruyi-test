#!/usr/bin/bash
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
    em_check_env || return 0

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

    local total_cpu=0 count=0
    local nproc=$(nproc)

    stress-ng --cpu $nproc --timeout 120s &
    em_track_pid $!
    local STRESS_PID=$!
    em_track_pid $STRESS_PID
    sleep 10

    for i in $(seq 1 5); do
        local cpu
        cpu=$(ps -p $EM_PID -o %cpu --no-headers 2>/dev/null | tr -d ' ')
        cpu=${cpu:-0}
        LOG_INFO "sample $i: %cpu=$cpu (per-core)"
        total_cpu=$(echo "$total_cpu + $cpu" | bc)
        count=$((count + 1))
        sleep 10
    done

    if [ "$count" -gt 0 ]; then
        local avg_per_core=$(echo "scale=1; $total_cpu / $count" | bc)
        local overhead_bp=$(echo "$avg_per_core * 100 / 1" | bc | cut -d. -f1)
        overhead_bp=$((overhead_bp / nproc))
        local overhead_pct=$(echo "scale=2; $overhead_bp / 100" | bc)
        LOG_INFO "elasticMem avg CPU: ${avg_per_core}%/core = ${overhead_pct}% of system ($nproc cores)"
        [ "$overhead_bp" -lt 1000 ]
        CHECK_RESULT $? 0 0 "CPU overhead ${overhead_pct}% exceeds 10% of system"
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
