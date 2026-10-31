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
# @Desc      :   Verify sample_interval and sample_count affect tune frequency
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
    em_write_light_config "[]" "false" 200 5
    em_start_service "light start failed"

    # confirm the parameters in the log
    em_assert_log_contains "PMU interval" "PMU interval not logged"
    em_assert_log_contains "tune every 5 samples" "tune every not logged correctly"

    # modify the parameters
    sed -i 's/sample_interval = 200/sample_interval = 500/' "$CONFIG_PATH"
    sed -i 's/sample_count = 5/sample_count = 2/' "$CONFIG_PATH"
    systemctl restart "$SERVICE_NAME" 2>/dev/null
    SLEEP_WAIT 2

    em_assert_log_contains "PMU interval 500 ms" "interval not updated to 500"
    em_assert_log_contains "tune every 2 samples" "sample_count not updated to 2"

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
