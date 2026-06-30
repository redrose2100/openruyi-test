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
    # whitelist has multiple keywords; paral only reads the first
    em_write_paral_config "[--executor-id, spark]"
    em_start_service "paral start failed"

    # confirm only the first keyword is activated
    em_assert_log_contains "cmdline_kw=--executor-id" "first keyword not activated"

    # start a process without --executor-id
    bash -c "sleep 30" &
    local PID1=$!
    em_track_pid "$PID1"
    kill -0 "$PID1"
    CHECK_RESULT $? 0 0 "process without keyword failed to start"
    SLEEP_WAIT 2

    # start a process with --executor-id
    bash -c "sleep 30 #--executor-id test" &
    local PID2=$!
    em_track_pid "$PID2"
    kill -0 "$PID2"
    CHECK_RESULT $? 0 0 "process with keyword failed to start"
    SLEEP_WAIT 2

    local aff2
    aff2=$(LC_ALL=C LC_ALL=C taskset -p $PID2 2>/dev/null | awk '{print $NF}')

    # the process with the keyword should be pinned (affinity differs from all CPUs)
    [ "$aff2" != "$(cat /sys/devices/system/cpu/present)" ]
    CHECK_RESULT $? 0 0 "process not bound by paral"

    em_safe_kill $PID1; em_safe_kill $PID2
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
