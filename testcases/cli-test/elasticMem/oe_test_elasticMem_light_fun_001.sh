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
# @Desc      :   Verify light mode creates em_node cgroups
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
    em_write_light_config
    em_start_service "light start failed"

    local N
    N=$(em_get_numa_count)
    for i in $(seq 0 $((N-1))); do
        local dir="$CGROUP_BASE/em_node$i"
        [ -d "$dir" ]
        CHECK_RESULT $? 0 0 "cgroup em_node$i not found"
        local cpus
        cpus=$(cat "$dir/cpuset.cpus" 2>/dev/null)
        local mems
        mems=$(cat "$dir/cpuset.mems" 2>/dev/null)
        [ -n "$cpus" ]
        CHECK_RESULT $? 0 0 "cpuset.cpus empty for em_node$i"
        [ -n "$mems" ]
        CHECK_RESULT $? 0 0 "cpuset.mems empty for em_node$i"
    done

    # verify only em_node naming, no elasticMem_ naming
    local wrong
    wrong=$(find "$CGROUP_BASE/" -maxdepth 1 -name 'elasticMem_*' 2>/dev/null | wc -l)
    [ "$wrong" -eq 0 ]
    CHECK_RESULT $? 0 0 "found unexpected elasticMem_ cgroup naming"

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
