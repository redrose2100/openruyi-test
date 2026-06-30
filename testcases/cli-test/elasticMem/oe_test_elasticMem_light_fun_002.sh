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
# @Desc      :   Verify CPU load balancing placement
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_install_elasticmem || exit 255
    em_backup_config
    em_stop_service
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_light_config "[]" "false"
    em_start_service "light start failed"

    # high load on NUMA0
    em_start_cpu_load 0 8 120
    pgrep -f 'SECONDS < end' >/dev/null
    CHECK_RESULT $? 0 0 "cpu load failed to start"
    SLEEP_WAIT 10

    # start a new process
    bash -c "sleep 30" &
    local NEW_PID=$!
    em_track_pid "$NEW_PID"
    kill -0 "$NEW_PID"
    CHECK_RESULT $? 0 0 "new process failed to start"
    SLEEP_WAIT 15

    # check the new process's cgroup
    local cgroup_line
    cgroup_line=$(grep cpuset "/proc/$NEW_PID/cgroup" 2>/dev/null)
    echo "$cgroup_line" | grep -q 'em_node'
    CHECK_RESULT $? 0 0 "new process not assigned to em_node cgroup"

    em_safe_kill "$NEW_PID"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    em_restore_config
    em_dnf_remove
    em_remove_elasticmem
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
