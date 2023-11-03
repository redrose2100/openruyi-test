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
    echo -e "hello world\nhello world" >testxz
    echo "hello world" >testxz1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xzdiff --normal testxz testxz1 | grep "2d1"
    CHECK_RESULT $? 0 0 "Test failed with option --normal"
    xzdiff -q testxz testxz1 | grep "Files testxz and testxz1 differ"
    CHECK_RESULT $? 0 0 "Test failed with option -q"
    xzdiff -s testxz testxz1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Test failed with option -s"
    xzdiff -c testxz testxz1 | grep "1,2"
    CHECK_RESULT $? 0 0 "Test failed with option -c"
    xzdiff -u testxz testxz1 | grep "1,2 +1"
    CHECK_RESULT $? 0 0 "Test failed with option -u"
    xzdiff -e testxz testxz1 | grep "2d"
    CHECK_RESULT $? 0 0 "Test failed with option -e"
    xzdiff -n testxz testxz1 | grep "d2 1"
    CHECK_RESULT $? 0 0 "Test failed with option -n"
    xzdiff -y testxz testxz1 | grep -c "hello world" | grep 2
    CHECK_RESULT $? 0 0 "Test failed with option -y"
    xzdiff -p testxz testxz1 | grep "\-\- 1 \-\-"
    CHECK_RESULT $? 0 0 "Test failed with option -p"
    xzdiff -T testxz testxz1 | grep "<"
    CHECK_RESULT $? 0 0 "Test failed with option -T"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf testxz testxz1
    LOG_INFO "End to restore the test environment."
}

main "$@"
