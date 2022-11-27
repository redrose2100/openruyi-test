#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test cvs
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "cvs"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cvs -v | grep 'Concurrent Versions System'
    CHECK_RESULT $? 0 0 "Failed option: cvs -v"
    ! cvs --version 2>&1 | grep 'unrecognized option' && cvs --version 2>&1 | grep 'Concurrent Versions System'
    CHECK_RESULT $? 0 0 "Failed option: cvs --version"
    ! cvs --help 2>&1 | grep 'unrecognized option' && cvs --help 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help"
    ! cvs --help-options 2>&1 | grep 'unrecognized option' && cvs --help-options 2>&1 | grep 'CVS global options'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
    ! cvs --help-commands 2>&1 | grep 'unrecognized option' && cvs --help-commands 2>&1 | grep 'CVS commands are'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-commands"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
