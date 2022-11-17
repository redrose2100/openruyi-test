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
   ! cvs --help edit 2>&1 | grep  'Unknown command' && cvs --help edit 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help editors 2>&1 | grep  'Unknown command' && cvs --help editors 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help export 2>&1 | grep  'Unknown command' && cvs --help export 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help history 2>&1 | grep  'Unknown command' && cvs --help history 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help import 2>&1 | grep  'Unknown command' && cvs --help import 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help init 2>&1 | grep  'Unknown command' && cvs --help init 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help log 2>&1 | grep  'Unknown command' && cvs --help log 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help login 2>&1 | grep  'Unknown command' && cvs --help login 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help logout 2>&1 | grep  'Unknown command' && cvs --help logout 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help pserver 2>&1 | grep  'Unknown command' && cvs --help pserver 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
   ! cvs --help rannotate 2>&1 | grep  'Unknown command' && cvs --help rannotate 2>&1 | grep 'Usage:'
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
