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

# Spec-backed schedule for the documented 4-NUMA [3,1,3,1] example (paralTune
# design doc, confirmed empirically). Asserted exactly only on a 4-NUMA host;
# any other topology is validated by the weight-proportion and
# placement-follows-schedule properties below.
EM_CAP_DOC_ORDER=(0 2 0 2 1 3 0 2)
# Parsed from the "ParalTune capacity NUMA schedule: [a,b,c]" log line.
EM_CAP_ORDER=()

# Echo a weights array of length N (alternating 3,1) as "[3,1,3,1,...]".
em_cap_weights_str() {
    local n=$1 i out=""
    for ((i = 0; i < n; i++)); do
        ((i % 2 == 0)) && out+="${out:+,}3" || out+="${out:+,}1"
    done
    echo "[$out]"
}

# Fill EM_CAP_ORDER from the capacity schedule line in the current log window.
em_cap_parse_order() {
    local line
    line=$(em_log_window | grep -o 'ParalTune capacity NUMA schedule: \[[0-9,]*\]' | head -1)
    line=${line##*[}
    line=${line%%]*}
    EM_CAP_ORDER=()
    [[ -n "$line" ]] && IFS=',' read -ra EM_CAP_ORDER <<< "$line"
}

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
    local N weights sum kw=em_cap_weight_probe
    N=$(em_get_numa_count)
    weights=$(em_cap_weights_str "$N")
    sum=$(( (N + 1) / 2 * 3 + N / 2 ))

    em_write_paral_config "[$kw]" 1 true "$weights"
    em_start_service "paral capacity_scheduling start failed"

    # capacity path active and a schedule line was logged
    em_assert_log_contains 'ParalTune capacity NUMA schedule: \[[0-9,]*\]' \
        "no capacity NUMA schedule line in log"

    em_cap_parse_order
    local order_len=${#EM_CAP_ORDER[@]}
    CHECK_RESULT "$order_len" "$sum" 0 "schedule length $order_len != sum(weights) $sum"

    # each node i appears weight[i] times in the generated schedule
    local i cnt expected v
    for ((i = 0; i < N; i++)); do
        expected=$(( (i % 2 == 0) ? 3 : 1 ))
        cnt=0
        for v in "${EM_CAP_ORDER[@]}"; do [ "$v" = "$i" ] && cnt=$((cnt + 1)); done
        CHECK_RESULT "$cnt" "$expected" 0 "node$i appears $cnt times in schedule, expected $expected"
    done

    # spec-backed exact order for the documented 4-NUMA [3,1,3,1] example
    if [ "$N" -eq 4 ]; then
        local ok=1 j
        for ((j = 0; j < ${#EM_CAP_ORDER[@]}; j++)); do
            [ "${EM_CAP_ORDER[$j]}" = "${EM_CAP_DOC_ORDER[$j]}" ] || { ok=0; break; }
        done
        CHECK_RESULT "$ok" 1 0 "schedule order mismatch (expect ${EM_CAP_DOC_ORDER[*]})"
    fi

    # placement follows the schedule: start sum processes one by one (kept alive
    # to avoid slot reuse), proc i must land on node schedule[i]
    local hold=60
    pids=()
    local _i pid cur waited online
    online=$(cat /sys/devices/system/cpu/online)
    for ((_i = 0; _i < sum; _i++)); do
        bash -c "sleep ${hold} & wait" "#$kw" &
        pid=$!
        em_track_pid "$pid"
        pids+=("$pid")
        # wait until paral pins this process before starting the next one, so the
        # capacity schedule is consumed in spawn order and the placement check
        # below is not racing the service
        waited=0
        while [ "$waited" -lt 10 ]; do
            cur=$(LC_ALL=C taskset -cp "$pid" 2>/dev/null | awk -F': ' '{print $2}')
            [ -n "$cur" ] && [ "$cur" != "$online" ] && break
            SLEEP_WAIT 1
            waited=$((waited + 1))
        done
    done

    local idx=0 got
    for p in "${pids[@]}"; do
        got=$(em_pid_node "$p")
        CHECK_RESULT "$got" "${EM_CAP_ORDER[$idx]}" 0 \
            "proc#$((idx + 1)) pid=$p on node '$got', schedule says ${EM_CAP_ORDER[$idx]}"
        idx=$((idx + 1))
    done

    # per-node placement counts match weights
    declare -A cnt
    for p in "${pids[@]}"; do
        got=$(em_pid_node "$p")
        [ -n "$got" ] || continue
        cnt[$got]=$((cnt[$got] + 1))
    done
    for ((i = 0; i < N; i++)); do
        expected=$(( (i % 2 == 0) ? 3 : 1 ))
        CHECK_RESULT "${cnt[$i]:-0}" "$expected" 0 "node$i placement count != weight $expected"
    done

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
