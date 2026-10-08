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
# @Desc      :   Verify slot reuse after process exit
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
    em_write_paral_config "[test]"
    em_start_service "paral start failed"

    # start process A; "sleep N & wait" keeps the "#test" keyword in cmdline
    bash -c 'sleep 30 & wait' "#test" &
    local A
    A=$!
    em_track_pid "$A"
    kill -0 "$A"
    CHECK_RESULT $? 0 0 "process A failed to start"
    SLEEP_WAIT 3
    # start process B
    bash -c 'sleep 30 & wait' "#test" &
    local B
    B=$!
    em_track_pid "$B"
    kill -0 "$B"
    CHECK_RESULT $? 0 0 "process B failed to start"
    SLEEP_WAIT 3
    local online cpuB cpuC
    online=$(cat /sys/devices/system/cpu/online)
    cpuB=$(LC_ALL=C taskset -cp "$B" 2>/dev/null | awk -F': ' '{print $2}')
    [ -n "$cpuB" ] && [ "$cpuB" != "$online" ]
    CHECK_RESULT $? 0 0 "process B was not pinned by paral"

    # stop A, start C
    em_safe_kill "$A"
    SLEEP_WAIT 3
    bash -c 'sleep 30 & wait' "#test" &
    local C
    C=$!
    em_track_pid "$C"
    kill -0 "$C"
    CHECK_RESULT $? 0 0 "process C failed to start"
    SLEEP_WAIT 3
    cpuC=$(LC_ALL=C taskset -cp "$C" 2>/dev/null | awk -F': ' '{print $2}')

    # C must be pinned as well and land on a different slot than B
    [ -n "$cpuC" ] && [ "$cpuC" != "$online" ]
    CHECK_RESULT $? 0 0 "process C was not pinned by paral"
    [ "$cpuC" != "$cpuB" ]
    CHECK_RESULT $? 0 0 "C got same affinity as B, slot not rotated"

    em_safe_kill $B; em_safe_kill $C
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
