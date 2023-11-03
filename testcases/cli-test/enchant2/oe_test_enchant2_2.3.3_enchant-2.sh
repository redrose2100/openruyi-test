#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   GaoNan ZhouZhenBin WuXiChuan
# @Contact   :   690895849@qq.com
# @Date      :   2022/07/24
# @License   :   Mulan PSL v2
# @Desc      :   TEST enchant-2 update
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    export LANG=en_US.UTF-8
    TMP_DIR="$(mktemp -d -t enchant2.XXXXXXXXXXXX)"
    echo "kylin" > ${TMP_DIR}/person_list
    echo "The kylin is a mythical animal.
I like playing mahjong." > ${TMP_DIR}/test.in
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "enchant2"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    enchant-2 -l -p ${TMP_DIR}/person_list ${TMP_DIR}/test.in | grep "mahjong"
    CHECK_RESULT $? 0 0 "option: -p error"
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"