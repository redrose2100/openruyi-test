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
# @Desc      :   Verify specifying config file path via command line argument
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_install_elasticmem || exit 255
    em_stop_service
    rm -rf /tmp/em_test
    mkdir -p /tmp/em_test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # create a standalone config
    cat > /tmp/em_test/custom.ini << EOF
policy = paral
log_level = debug
log_file = /tmp/em_test/elasticMem.log
whitelist = [test-custom]
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF

    # run directly with the specified config path
    /usr/bin/elasticMem /tmp/em_test/custom.ini &
    local PID=$!
    em_track_pid "$PID"
    kill -0 "$PID"
    CHECK_RESULT $? 0 0 "elasticMem custom-config process failed to start"
    SLEEP_WAIT 3

    ps -p $PID > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "elasticMem not running with custom config"

    # confirm log output goes to the custom path
    [ -f /tmp/em_test/elasticMem.log ]
    CHECK_RESULT $? 0 0 "custom log file not created"

    grep -q "Config loaded successfully" /tmp/em_test/elasticMem.log
    CHECK_RESULT $? 0 0 "config not loaded from custom path"

    # graceful exit
    em_safe_kill $PID
    SLEEP_WAIT 2

    ps -p $PID > /dev/null 2>&1 && LOG_ERROR "process still running after SIGTERM"
    CHECK_RESULT $? 1 0 "SIGTERM graceful exit failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    rm -rf /tmp/em_test
    em_remove_elasticmem
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
