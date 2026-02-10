#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/07/15
# @License   :   Mulan PSL v2
# @Desc      :   Test tracepath6
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if echo "${NODE1_OS_VERSION}" | grep -E "debian|velinux";then
        DNF_INSTALL iputils-tracepath
    else
        DNF_INSTALL traceroute
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    traceroute6 2>&1 | grep -iA 1 "Usage" | grep "traceroute6"
    CHECK_RESULT $? 0 0 "Failed to execute traceroute6"
    if echo "${NODE1_OS_VERSION}" | grep -E "debian|velinux";then
        tracepath 2>&1 | grep tracepath
        CHECK_RESULT $? 0 0 "Failed to repeat execute tracepath"
    else
        tracepath6 2>&1 | grep tracepath
        CHECK_RESULT $? 0 0 "Failed to repeat execute tracepath6"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
