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
# @Desc      :   Verify paral distributes processes round-robin across NUMA
# #############################################

source "${OET_PATH}"/testcases/function-test/pkgs-test/elasticMem/common/em_common.sh

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
    em_write_paral_config "[test]"
    em_start_service "paral start failed"

    local M N
    N=$(em_get_numa_count)
    M=$((2 * N))

    # start processes in batch; "sleep N & wait" keeps bash alive so the "#test"
    # keyword stays in /proc/<pid>/cmdline for the whole process lifetime,
    # instead of only in the transient exec argv
    local pids=()
    for _ in $(seq 1 "$M"); do
        bash -c 'sleep 30 & wait' "#test" &
        em_track_pid "$!"
        pids+=("$!")
    done
    local alive=0 p
    for p in "${pids[@]}"; do
        kill -0 "$p" 2>/dev/null && alive=1 && break
    done
    [ "$alive" -eq 1 ]
    CHECK_RESULT $? 0 0 "test processes failed to start"
    SLEEP_WAIT 5

    # count distribution per NUMA; each process is bound to nr_cpus=1 cpu
    declare -A node_count
    local node
    for pid in "${pids[@]}"; do
        node=$(em_pid_node "$pid") || node="unknown"
        node_count[$node]=$((node_count[$node] + 1))
    done

    # every process must have been pinned to a node
    [ "${node_count[unknown]:-0}" -eq 0 ]
    CHECK_RESULT $? 0 0 "some processes were not pinned to any node"

    # verify even distribution (difference <= 1)
    local min_count=999
    local max_count=0
    for nd in $(seq 0 $((N-1))); do
        local cnt=${node_count[$nd]:-0}
        [ "$cnt" -lt "$min_count" ] && min_count=$cnt
        [ "$cnt" -gt "$max_count" ] && max_count=$cnt
    done
    [ $((max_count - min_count)) -le 1 ]
    CHECK_RESULT $? 0 0 "NUMA distribution not uniform"

    # cleanup
    for p in "${pids[@]}"; do em_safe_kill "$p"; done

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
