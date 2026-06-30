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
# @Desc      :   Verify short-lived processes are not missed
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_install_elasticmem || exit 255
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # use debug log for counting
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = debug
log_file = $LOG_FILE
whitelist = [test]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    em_start_service "paral start failed"

    # create 50 short-lived processes (bash stays alive with #test in cmdline, ensuring capture and pinning;
    # use "sleep 5 & wait" to avoid bash exec'ing sleep and losing #test from cmdline)
    local batch_pids=() _p _alive=0
    for _ in $(seq 1 50); do
        bash -c 'sleep 5 & wait' "#test" &
        _p=$!
        batch_pids+=("$_p")
        em_track_pid "$_p"
    done
    for _p in "${batch_pids[@]}"; do
        kill -0 "$_p" 2>/dev/null && { _alive=1; break; }
    done
    [ "$_alive" -eq 1 ]
    CHECK_RESULT $? 0 0 "short-lived processes failed to start"
    wait
    SLEEP_WAIT 3

    # count pinning records (elasticMem logs to file; count via the mark window)
    local count
    count=$(em_log_count "ParalTune set pid")
    [ "$count" -ge 45 ]
    CHECK_RESULT $? 0 0 "capture rate too low: $count/50"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    em_restore_config
    em_remove_elasticmem
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
