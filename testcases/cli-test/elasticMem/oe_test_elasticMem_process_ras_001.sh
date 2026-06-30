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
# @Desc      :   Verify graceful exit on SIGTERM
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
    # === paral mode ===
    em_write_paral_config "[test]"
    em_start_service "paral start failed"

    local pid
    pid=$(em_get_service_pid)
    em_safe_kill "$pid"
    SLEEP_WAIT 3

    ps -p "$pid" > /dev/null 2>&1 && LOG_ERROR "paral process still alive after SIGTERM"
    CHECK_RESULT $? 1 0 "paral SIGTERM graceful exit failed"

    # check tracefs cleanup
    local enable_val
    enable_val=$(cat /sys/kernel/debug/tracing/events/sched/sched_process_exec/enable 2>/dev/null)
    [ "$enable_val" != "1" ]
    CHECK_RESULT $? 0 0 "trace event not disabled after exit"

    # === light mode ===
    em_write_light_config
    em_start_service "light start failed"

    pid=$(em_get_service_pid)
    em_safe_kill "$pid"
    SLEEP_WAIT 3

    ps -p "$pid" > /dev/null 2>&1 && LOG_ERROR "light process still alive after SIGTERM"
    CHECK_RESULT $? 1 0 "light SIGTERM graceful exit failed"

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
