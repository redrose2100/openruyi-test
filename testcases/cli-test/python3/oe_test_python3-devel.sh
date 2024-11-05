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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023/08.17
# @License   :   Mulan PSL v2
# @Desc      :   File system common command python3-devel
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    python3-config | grep Usage
    CHECK_RESULT $? 0 0 "python3-config command execution failure"
    python3-config --includes | grep "/usr/include/python3"
    CHECK_RESULT $? 0 0 "header file location display failed"
    python3-config --ldflags | grep -E "/usr/lib64|/usr/lib"
    CHECK_RESULT $? 0 0 "python parameter display failure"
    python3-config --libs | grep ldl
    CHECK_RESULT $? 0 0 "library file list fails to be displayed"

}
function post_test() {
    DNF_REMOVE "$@"
}

main "$@"
