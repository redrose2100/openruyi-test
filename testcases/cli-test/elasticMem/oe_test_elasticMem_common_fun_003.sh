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
# @Desc      :   Verify light mode does not filter when whitelist is empty
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
    em_write_light_config "[]" "false"
    em_start_service "light start failed"

    # start the test process (CPU spinner; light mode assigns it to an em_node cgroup)
    bash -c '(( end = SECONDS + 60 )); while (( SECONDS < end )); do :; done' &
    local PID
    PID=$!
    em_track_pid "$PID"
    kill -0 "$PID"
    CHECK_RESULT $? 0 0 "test process failed to start"
    SLEEP_WAIT 15

    # after a tune cycle, check whether the process is assigned to a cgroup
    local found=0
    for cg in "$CGROUP_BASE"/em_node*/cgroup.procs; do
        [ -f "$cg" ] && grep -q "$PID" "$cg" 2>/dev/null && found=1 && break
    done
    [ "$found" -eq 1 ]
    CHECK_RESULT $? 0 0 "process not assigned to any cgroup"

    em_safe_kill "$PID"
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
