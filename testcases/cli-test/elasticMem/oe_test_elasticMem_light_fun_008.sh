#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xu_yishen
# @Contact   :   xuyishen3@huawei.com
# @Date      :   2026/06/30
# @License   :   Mulan PSL v2
# @Desc      :   Verify balance triggers under load imbalance
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_install_elasticmem || exit 255
    em_backup_config
    em_stop_service
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
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
    em_start_service "light start failed"

    # heavy load on NUMA0
    em_start_cpu_load 0 8 120
    pgrep -f 'SECONDS < end' >/dev/null
    CHECK_RESULT $? 0 0 "cpu load failed to start"
    SLEEP_WAIT 15

    # add more load
    local extra_pids=() _p _alive=0
    for _ in $(seq 1 4); do
        numactl --cpunodebind=0 --membind=0 bash -c "while true; do :; done" &
        _p=$!
        extra_pids+=("$_p")
        em_track_pid "$_p"
    done
    for _p in "${extra_pids[@]}"; do
        kill -0 "$_p" 2>/dev/null && { _alive=1; break; }
    done
    [ "$_alive" -eq 1 ]
    CHECK_RESULT $? 0 0 "extra cpu load failed to start"
    SLEEP_WAIT 20

    # check whether balance triggered (elasticMem's balance action is "Pre-bind process ... to cgroup")
    em_assert_log_contains "Pre-bind process" "balance not triggered under load imbalance"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    em_restore_config
    em_dnf_remove
    em_remove_elasticmem
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
