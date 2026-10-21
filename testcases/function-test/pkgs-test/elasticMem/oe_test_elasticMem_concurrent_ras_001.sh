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
# @Desc      :   Verify first instance survives a second instance launch
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
    em_write_paral_config "[__nonexist__]"
    em_start_service "first instance start failed"

    # attempt to start a second instance
    /usr/bin/elasticMem /etc/elasticMem.ini &
    local PID2=$!
    em_track_pid "$PID2"
    kill -0 "$PID2"
    CHECK_RESULT $? 0 0 "second elasticMem instance failed to start"
    SLEEP_WAIT 2

    ps -p "$PID2" > /dev/null 2>&1
    em_safe_kill "$PID2"

    # confirm the first instance is still alive
    systemctl is-active "$SERVICE_NAME" --quiet
    CHECK_RESULT $? 0 0 "first instance was affected"

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
