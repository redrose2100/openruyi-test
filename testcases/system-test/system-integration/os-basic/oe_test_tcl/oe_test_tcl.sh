#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-03-06
# @License   :   Mulan PSL v2
# @Desc      :   Use tcl case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa | grep tcl
    CHECK_RESULT $? 0 0 "please check TCL language"
    cat > hello.tcl << EOF
#!/usr/bin/tclsh
puts stdout {Hello, World!}
EOF
    CHECK_RESULT $? 0 0 "Error, fail to create hello.c"
    tclsh hello.tcl
    CHECK_RESULT $? 0 0 "Error, please check 'hello.tcl'"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    rm -rf hello.tcl
    LOG_INFO "End to clean the test environment."
}
main "$@"
