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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2022-08-29
# @License   :   Mulan PSL v2
# @Desc      :   diffstat function verification
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffstat diffutils"
    mkdir diff_test1 diff_test2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    echo -e "abc\n123\ndef" >diff_test1/test.txt
    echo -e "abc\n123\ndef" >diff_test2/test.txt
    diff diff_test1 diff_test2 | diffstat | grep "0 files changed"
    CHECK_RESULT $? 0 0 "The file content is abnormal"
    echo -e "abc\n456\njqk" >./diff_test2/test.txt
    diff diff_test1 diff_test2 | diffstat | grep "2 insertions(+), 2 deletions(-)"
    CHECK_RESULT $? 0 0 "The file content is abnormal"
    diff diff_test1 diff_test2 | diffstat -l | grep "test.txt"
    CHECK_RESULT $? 0 0 "diffstat -l 输出异常"
    diff diff_test1 diff_test2 | diffstat -p1 | grep "test.txt"
    CHECK_RESULT $? 0 0 "diffstat -p1 输出异常"
    echo "" | diffstat | grep "0 files changed"
    CHECK_RESULT $? 0 0 "diffstat 空输入输出异常"
    diffstat --invalid 2>&1 | grep -E "invalid|unrecognized|illegal"
    CHECK_RESULT $? 0 0 "diffstat 未能正确处理无效参数"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf diff_test1 diff_test2
    LOG_INFO "End to restore the test environment."
}

main "$@"
