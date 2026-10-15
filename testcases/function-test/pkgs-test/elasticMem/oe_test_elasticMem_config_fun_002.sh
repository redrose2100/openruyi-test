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
# @Desc      :   Verify policy=light service start and cgroup creation
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
    # configure light mode
    em_write_light_config "[]" "true"
    grep '^policy.*light' "$CONFIG_PATH"
    CHECK_RESULT $? 0 0 "policy not light"

    # start the service
    em_start_service "elasticMem start failed"

    systemctl status "$SERVICE_NAME" --no-pager -l | grep "active (running)"
    CHECK_RESULT $? 0 0 "service not active"

    # check logs
    em_assert_log_contains "Executing light tune" "log missing light tune"

    # check cgroup creation
    local N
    N=$(em_get_numa_count)
    for i in $(seq 0 $((N-1))); do
        local dir="$CGROUP_BASE/em_node$i"
        [ -d "$dir" ]
        CHECK_RESULT $? 0 0 "cgroup em_node$i not found"
        [ -f "$dir/cpuset.cpus" ]
        CHECK_RESULT $? 0 0 "cpuset.cpus missing for em_node$i"
        [ -f "$dir/cpuset.mems" ]
        CHECK_RESULT $? 0 0 "cpuset.mems missing for em_node$i"
    done

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
