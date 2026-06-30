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
# @Date      :   2026/09/04
# @License   :   Mulan PSL v2
# @Desc      :   Verify paral capacity_scheduling rotates by numa weights
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

# Spec-backed schedule for capacity_scheduling=true, numa_capacity_weights=[3,1,3,1]:
# "ParalTune capacity NUMA schedule: [0,2,0,2,1,3,0,2]" (paralTune design doc,
# confirmed empirically on a 4-NUMA host). Valid only on 4 NUMA nodes.
EM_CAP_EXPECTED=(0 2 0 2 1 3 0 2)

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    local N
    N=$(em_get_numa_count)
    [ "$N" -eq 4 ] || { LOG_WARN "NUMA != 4 ($N), capacity_scheduling case skip"; exit 255; }
    em_install_elasticmem || exit 255
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_paral_config "[test]" 1 true "[3,1,3,1]"
    em_start_service "paral capacity_scheduling start failed"

    em_assert_log_contains 'ParalTune capacity NUMA schedule: \[0,2,0,2,1,3,0,2\]' \
        "capacity schedule order mismatch, expect [0,2,0,2,1,3,0,2]"

    local sum=${#EM_CAP_EXPECTED[@]}
    local hold=60
    pids=()
    local _i
    for ((_i = 0; _i < sum; _i++)); do
        bash -c "sleep ${hold} #test" &
        em_track_pid "$!"
        pids+=("$!")
        SLEEP_WAIT 1
    done
    SLEEP_WAIT 2

    local idx=0 got
    for p in "${pids[@]}"; do
        got=$(em_pid_node "$p")
        CHECK_RESULT "$got" "${EM_CAP_EXPECTED[$idx]}" 0 \
            "proc#$((idx + 1)) pid=$p on node '$got', expect ${EM_CAP_EXPECTED[$idx]}"
        idx=$((idx + 1))
    done

    declare -A cnt
    for p in "${pids[@]}"; do
        got=$(em_pid_node "$p")
        [ -n "$got" ] || continue
        cnt[$got]=$((cnt[$got] + 1))
    done
    CHECK_RESULT "${cnt[0]:-0}" 3 0 "node0 count != weight 3"
    CHECK_RESULT "${cnt[1]:-0}" 1 0 "node1 count != weight 1"
    CHECK_RESULT "${cnt[2]:-0}" 3 0 "node2 count != weight 3"
    CHECK_RESULT "${cnt[3]:-0}" 1 0 "node3 count != weight 1"

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
