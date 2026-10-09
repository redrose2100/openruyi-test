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
# @Desc      :   Verify nr_cpus binding range is correct
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
    local NR=4
    em_write_paral_config "[test]" "$NR"
    em_start_service "paral start failed"

    # "sleep N & wait" keeps bash alive as the process whose cmdline carries the
    # "#test" keyword for its whole lifetime (a bare "bash -c 'sleep N #test'"
    # only exposes it in the transient exec argv)
    bash -c 'sleep 30 & wait' "#test" &
    local PID1=$!
    em_track_pid "$PID1"
    kill -0 "$PID1"
    CHECK_RESULT $? 0 0 "test process 1 failed to start"
    bash -c 'sleep 30 & wait' "#test" &
    local PID2=$!
    em_track_pid "$PID2"
    kill -0 "$PID2"
    CHECK_RESULT $? 0 0 "test process 2 failed to start"
    SLEEP_WAIT 5

    # each matched process is pinned to exactly nr_cpus cpus
    local _pids=("$PID1" "$PID2") pid aff n part s e oIFS=$IFS
    IFS=','
    for pid in "${_pids[@]}"; do
        aff=$(LC_ALL=C taskset -cp "$pid" 2>/dev/null | awk -F': ' '{print $2}')
        n=0
        for part in $aff; do
            if [[ "$part" == *-* ]]; then
                s=${part%%-*}; e=${part##*-}
                n=$((n + e - s + 1))
            else
                n=$((n + 1))
            fi
        done
        CHECK_RESULT "$n" "$NR" 0 "PID $pid bound to $n cpus, expected nr_cpus=$NR (list=$aff)"
    done
    IFS=$oIFS

    em_safe_kill "$PID1"; em_safe_kill "$PID2"
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
