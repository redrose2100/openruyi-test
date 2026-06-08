#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_light_fun.008 - balance 在负载失衡时触发
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
    em_check_env || return 0

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

    > "$LOG_FILE"

    numactl --cpunodebind=0 --membind=0 stress-ng --cpu $(nproc --all) --timeout 120s &
    em_track_pid $!
    local HIGH_PID=$!
    em_track_pid $HIGH_PID
    sleep 15

    for i in $(seq 1 4); do
        numactl --cpunodebind=0 --membind=0 bash -c "while true; do :; done" &
        em_track_pid $!
    done
    sleep 20

    local migrate_cnt
    migrate_cnt=$(grep -cE 'MigratePages|migrate pages' "$LOG_FILE" 2>/dev/null)
    migrate_cnt=${migrate_cnt:-0}
    LOG_INFO "migration log entries: $migrate_cnt"
    [ "$migrate_cnt" -gt 0 ]
    CHECK_RESULT $? 0 0 "balance not triggered under load imbalance"

    for cg in "$CGROUP_BASE"/em_node*/cgroup.procs; do
        [ -f "$cg" ] || continue
        local count=$(wc -l < "$cg" 2>/dev/null)
        LOG_INFO "$(dirname $cg): $count procs"
    done

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
