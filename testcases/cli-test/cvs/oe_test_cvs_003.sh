#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test cvs commands
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cvs
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
   ! cvs --help release 2>&1 | grep 'Unknown command' && cvs --help release 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help remove 2>&1 | grep 'Unknown command' && cvs --help remove 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help rlog 2>&1 | grep 'Unknown command' && cvs --help rlog 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help rtag 2>&1 | grep 'Unknown command' && cvs --help rtag 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help server 2>&1 | grep 'Unknown command' && cvs --help server 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help status 2>&1 | grep 'Unknown command' && cvs --help status 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help tag 2>&1 | grep 'Unknown command' && cvs --help tag 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help unedit 2>&1 | grep 'Unknown command' && cvs --help unedit 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help update 2>&1 | grep 'Unknown command' && cvs --help update 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help version 2>&1 | grep 'Unknown command' && cvs --help version 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help watch 2>&1 | grep 'Unknown command' && cvs --help watch 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf cvs_test/ init/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
