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
# @Desc      :   Verify processes bound to non-em_node cgroups are filtered
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_light_config "[]" "false"
    em_start_service "light start failed"

    # manually create a non-em_node cgroup
    mkdir -p "$CGROUP_BASE/manual_test"
    echo "0-3" > "$CGROUP_BASE/manual_test/cpuset.cpus"
    echo "0" > "$CGROUP_BASE/manual_test/cpuset.mems"

    # start a process and bind it to the manual cgroup
    bash -c "sleep 30" &
    local PID=$!
    em_track_pid "$PID"
    kill -0 "$PID"
    CHECK_RESULT $? 0 0 "test process failed to start"
    echo $PID > "$CGROUP_BASE/manual_test/cgroup.procs" 2>/dev/null
    SLEEP_WAIT 2

    # verify the current cgroup
    grep -q 'manual_test' "/proc/$PID/cgroup" 2>/dev/null
    CHECK_RESULT $? 0 0 "process not bound to manual_test"

    # wait for a tune cycle
    SLEEP_WAIT 20

    # verify it stays in manual_test
    grep -q 'manual_test' "/proc/$PID/cgroup" 2>/dev/null
    CHECK_RESULT $? 0 0 "process was moved from manual_test cgroup"

    em_safe_kill $PID
    rmdir "$CGROUP_BASE/manual_test" 2>/dev/null
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    em_restore_config
    rmdir "$CGROUP_BASE/manual_test" 2>/dev/null
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
