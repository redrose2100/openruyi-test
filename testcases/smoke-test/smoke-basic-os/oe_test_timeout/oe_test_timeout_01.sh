#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojiasheng
# @Contact   :   maojiasheng@uniontech.com
# @Date      :   2026-06-12
# @License   :   Mulan PSL v2
# @Desc      :   test timeout help/version/signal/timeout functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # help
    timeout --help | grep -- "--signal"
    CHECK_RESULT $? 0 0 "timeout help check failed"

    # version
    timeout --version | grep "coreutils"
    CHECK_RESULT $? 0 0 "timeout version check failed"

    # command completes before timeout
    timeout 3 sleep 1
    CHECK_RESULT $? 0 0 "normal execution failed"

    # command timeout (exit code 124)
    timeout 1 sleep 3
    CHECK_RESULT $? 124 0 "timeout execution failed"

    # preserve-status
    timeout --preserve-status 3 sh -c "exit 10"
    CHECK_RESULT $? 10 0 "preserve-status failed"

    # signal option
    timeout -s TERM 1 sleep 3
    CHECK_RESULT $? 124 0 "timeout signal handling failed"

    # invalid option
    timeout --invalid-option >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "invalid option should fail"

    # kill-after
    timeout -k 1 1 sleep 10
    CHECK_RESULT $? 124 0 "timeout kill-after failed"
    
    pgrep -x sleep
    CHECK_RESULT $? 0 1 "sleep process still exists after timeout"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

