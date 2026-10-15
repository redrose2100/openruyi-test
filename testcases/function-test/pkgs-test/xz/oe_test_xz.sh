#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2023/07/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in xz package
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL xz
    echo "hello world" >testxz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xzgrep hello testxz | grep "hello"
    CHECK_RESULT $? 0 0 "The command xzgrep failed to execute"
    xzegrep "hello|world" testxz | grep "hello world"
    CHECK_RESULT $? 0 0 "The command xzegrep failed to execute"
    xzfgrep hello testxz | grep "hello"
    CHECK_RESULT $? 0 0 "The command xzfgrep failed to execute"
    xzmore testxz | grep "> testxz <"
    CHECK_RESULT $? 0 0 "The command xzmore failed to execute"
    xzless testxz | grep "hello world"
    CHECK_RESULT $? 0 0 "The command xzless failed to execute"
    xzgrep --help | grep -i "Usage: xzgrep"
    CHECK_RESULT $? 0 0 "xzgrep does not display help information"
    xzegrep --help | grep -i "Usage: xzegrep"
    CHECK_RESULT $? 0 0 "xzegrep does not display help information"
    xzfgrep --help | grep -i "Usage: xzfgrep"
    CHECK_RESULT $? 0 0 "xzfgrep does not display help information"
    xzmore --help | grep -i "Usage: xzmore"
    CHECK_RESULT $? 0 0 "xzmore does not display help information"
    xzless --help | grep -i "Usage: xzless"
    CHECK_RESULT $? 0 0 "xzless does not display help information"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf testxz
    LOG_INFO "End to restore the test environment."
}

main "$@"
