#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   xieshouhang
# @Contact   :   1069178568@qq.com
# @Date      :   2024/10/30
# @Desc      :   user identity authentication sm test
# ##################################
# shellcheck disable=SC2002,SC2119


source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL findutils
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    find /etc -depth -name passwd | grep "/etc/passwd"
    CHECK_RESULT $? 0 0
    find /etc -daystart -name passwd | grep "/etc/passwd"
    CHECK_RESULT $? 0 0
    find /etc -follow -name passwd | grep "/etc/passwd"
    CHECK_RESULT $? 0 0
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"


