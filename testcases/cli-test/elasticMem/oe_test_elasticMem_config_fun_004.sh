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
# @Desc      :   Verify paral<->light switch requires restart
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
    # start paral mode
    em_write_paral_config "[test]" 1
    em_start_service "paral mode start failed"

    # confirm paral is running
    em_assert_log_contains "ParalTune activated" "paral not activated"

    # change config to light without restart
    sed -i 's/^policy.*/policy = light/' "$CONFIG_PATH"
    SLEEP_WAIT 15

    # confirm no light tune log appears (no hot reload)
    em_assert_not_log_contains "light tune" "light tune appeared without restart"

    # restart the service
    systemctl restart "$SERVICE_NAME" 2>/dev/null
    SLEEP_WAIT 3

    # confirm switch to light
    em_assert_log_contains "Executing light tune" "light tune not started after restart"

    [ -d "$CGROUP_BASE/em_node0" ]
    CHECK_RESULT $? 0 0 "em_node0 cgroup not created after switch"

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
