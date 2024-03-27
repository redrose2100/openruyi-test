#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lihe
# @Contact   :   lihea@uniontech.com
# @Date      :   2024-03-26
# @License   :   Mulan PSL v2
# @Desc      :   test userdel
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    useradd oe_test_userdel

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    userdel -rf oe_test_userdel

    grep oe_test_userdel /etc/passwd

    CHECK_RESULT $? 0 1 "check userdel fail please del oe_test_userdel user."

    ls /home/oe_test_userdel

    HECK_RESULT $? 0 1 "check userdel fail please del oe_test_userdel user."

    LOG_INFO "End to run test."
}

main "$@"
