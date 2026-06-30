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
    em_backup_config
    em_stop_service
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_paral_config "[test]"
    em_start_service "paral start failed"

    # start process A
    bash -c "sleep 30 #test" &
    local A
    A=$!
    em_track_pid "$A"
    kill -0 "$A"
    CHECK_RESULT $? 0 0 "process A failed to start"
    SLEEP_WAIT 2
    # start process B
    bash -c "sleep 30 #test" &
    local B
    B=$!
    em_track_pid "$B"
    kill -0 "$B"
    CHECK_RESULT $? 0 0 "process B failed to start"
    SLEEP_WAIT 2
    local cpuB
    cpuB=$(LC_ALL=C taskset -p "$B" 2>/dev/null | awk '{print $NF}')

    # stop A, start C
    em_safe_kill $A
    SLEEP_WAIT 2
    bash -c "sleep 30 #test" &
    local C
    C=$!
    em_track_pid "$C"
    kill -0 "$C"
    CHECK_RESULT $? 0 0 "process C failed to start"
    SLEEP_WAIT 2
    local cpuC
    cpuC=$(LC_ALL=C taskset -p "$C" 2>/dev/null | awk '{print $NF}')

    # C should be assigned to a different NUMA than B or the next cluster
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
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
