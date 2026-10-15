#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   hanson_fang
# @Contact   :   490538494@qq.com
# @Date      :   2023/07/19
# @License   :   Mulan PSL v2
# @Desc      :   Test ifenslave command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "iputils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ifenslave -h | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave -h execute failed"
    ifenslave --h | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave --h execute failed"
    ifenslave --help | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave --help execute failed"
    ifenslave -V | grep "ifenslave.c"
    CHECK_RESULT $? 0 0 "ifenslave -V execute failed"
    ifenslave --version | grep "ifenslave.c"
    CHECK_RESULT $? 0 0 "ifenslave --version execute failed"
    ifenslave -u | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave -u execute failed"
    ifenslave --usage | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave --usage execute failed"
    ifenslave -a | grep "The result of"
    CHECK_RESULT $? 0 0 "ifenslave -a execute failed"
    ifenslave --all-interfaces | grep "The result of"
    CHECK_RESULT $? 0 0 "ifenslave -all-interfaces execute failed"
    ifenslave -v 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave -v execute failed"
    ifenslave --verbose 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "ifenslave -verbose execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
