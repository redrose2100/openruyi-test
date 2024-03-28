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
# @Date      :   2024-03-28
# @License   :   Mulan PSL v2
# @Desc      :   test echo file
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    echo "111" > /tmp/oe_test_echo_file
    
    grep 111 /tmp/oe_test_echo_file

    CHECK_RESULT $? 0 0 "Failed to execute echo"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f /tmp/oe_test_echo_file

    LOG_INFO "End to restore the test environment."
}

main "$@"
