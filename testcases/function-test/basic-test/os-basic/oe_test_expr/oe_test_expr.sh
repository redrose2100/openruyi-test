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
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2023-04-14
# @License   :   Mulan PSL v2
# @Desc      :   Command test-expr 
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expr substr "this is a test" 3 5|grep is
    CHECK_RESULT $? 0 0 "check Tail's result fail"
    expr index "sarasara"  a |grep 2
    CHECK_RESULT $? 0 0 "check expr's help manual fail"
    expr --version | grep "expr"
    CHECK_RESULT $? 0 0 "check expr's version fail"
    expr 14 % 9 |grep 5
    CHECK_RESULT $? 0 0 "check command fail"
    expr 10 + 10 |grep 20
    CHECK_RESULT $? 0 0 "check command fail"
    expr 30 \* 3 |grep 90
    CHECK_RESULT $? 0 0 "check command fail"
    expr 10 - 9 |grep 1
    CHECK_RESULT $? 0 0 "check command fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"




