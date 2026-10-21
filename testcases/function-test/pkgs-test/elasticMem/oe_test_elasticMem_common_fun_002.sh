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
# @Desc      :   Verify paral whitelist only takes the first keyword
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
    # the whitelist holds two keywords but paral only reads the first one
    em_write_paral_config "[--executor-id, spark]"
    em_start_service "paral start failed"

    # confirm only the first keyword activated paral
    em_assert_log_contains "cmdline_kw=--executor-id" "first keyword not activated"

    # "sleep N & wait" keeps bash in place as the process whose cmdline carries
    # the keyword for its whole lifetime; a bare "bash -c 'sleep N #kw'" only
    # exposes it in the transient exec argv
    bash -c 'sleep 30 & wait' "#--executor-id test" &
    local PID1=$!
    em_track_pid "$PID1"
    kill -0 "$PID1"
    CHECK_RESULT $? 0 0 "process with first keyword failed to start"

    # a process carrying only the second keyword must stay unbound
    bash -c 'sleep 30 & wait' "#spark test" &
    local PID2=$!
    em_track_pid "$PID2"
    kill -0 "$PID2"
    CHECK_RESULT $? 0 0 "process with second keyword failed to start"

    # a process carrying no keyword must stay unbound as well
    bash -c "sleep 30" &
    local PID3=$!
    em_track_pid "$PID3"
    kill -0 "$PID3"
    CHECK_RESULT $? 0 0 "process without keyword failed to start"
    SLEEP_WAIT 5

    local aff1 aff2 aff3 online
    online=$(cat /sys/devices/system/cpu/online)
    aff1=$(LC_ALL=C taskset -cp "$PID1" 2>/dev/null | awk -F': ' '{print $2}')
    aff2=$(LC_ALL=C taskset -cp "$PID2" 2>/dev/null | awk -F': ' '{print $2}')
    aff3=$(LC_ALL=C taskset -cp "$PID3" 2>/dev/null | awk -F': ' '{print $2}')

    # the process carrying the first keyword is pinned to nr_cpus=1 cpu
    [ -n "$aff1" ] && [ "$aff1" != "$online" ]
    CHECK_RESULT $? 0 0 "first keyword process not bound by paral (affinity=$aff1)"
    # the second keyword is ignored, its process keeps the full online set
    [ "$aff2" = "$online" ]
    CHECK_RESULT $? 0 0 "second keyword was honoured unexpectedly (affinity=$aff2)"
    # no keyword, no binding
    [ "$aff3" = "$online" ]
    CHECK_RESULT $? 0 0 "process without keyword was bound unexpectedly (affinity=$aff3)"

    em_safe_kill "$PID1"; em_safe_kill "$PID2"; em_safe_kill "$PID3"
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
