#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_noise_prf.001 - elasticMem 自身底噪
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

    # === paral 模式底噪 ===
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = error
log_file = $LOG_FILE
whitelist = [__no_match__]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"

    local EM_PID=$(em_get_service_pid)
    local rss_paral=$(awk '/VmRSS/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    local thr_paral=$(awk '/Threads/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    LOG_INFO "Paral: RSS=${rss_paral}kB Threads=${thr_paral}"

    em_stop_service

    # === light 模式底噪 ===
    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = error
log_file = $LOG_FILE
whitelist = [__no_match__]
comm_whitelist = []
memory_migration = false
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    EM_PID=$(em_get_service_pid)
    local rss_light=$(awk '/VmRSS/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    local thr_light=$(awk '/Threads/{print $2}' /proc/$EM_PID/status 2>/dev/null)
    LOG_INFO "Light: RSS=${rss_light}kB Threads=${thr_light}"

    [ "$rss_paral" -lt 102400 ]   # < 100MB
    CHECK_RESULT $? 0 0 "paral RSS ${rss_paral}kB too large"
    [ "$rss_light" -lt 102400 ]
    CHECK_RESULT $? 0 0 "light RSS ${rss_light}kB too large"

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
