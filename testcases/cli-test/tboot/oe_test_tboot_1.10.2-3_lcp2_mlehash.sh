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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of tboot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL tboot
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lcp2_mlehash --create --alg sha1 --verbose --cmdline "logging=serial,memory,vga" /boot/tboot.gz
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --cmdline --alg --verbose failed"
    lcp2_mlehash --help 2>&1 | grep 'Usage: lcp2_mlehash'
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash --help failed"
    lcp2_mlehash --version 2>&1 | grep -E "lcp2_mlehash version: [0-9]"
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash --version failed"
    LOG_INFO "End of the test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
