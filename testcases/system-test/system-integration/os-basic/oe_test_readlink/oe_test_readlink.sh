#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   youwei
# @Contact   :   youwei@uniontech.com
# @Date      :   2024-03-20
# @License   :   Mulan PSL v2
# @Desc      :   Command test-readlink 
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir -pv /tmp/testdir
    path="testdir"
    touch /tmp/"${path}"/file
    touch /tmp/"${path}"/file1
    ln -s /tmp/"${path}"/file /tmp/"${path}"/link_1_file
    ln -s /tmp/"${path}"/link_1_file /tmp/"${path}"/link_1_1_file
    ln -s /tmp/"${path}"/file1 /tmp/"${path}"/link_1_file1
    ln -s /tmp/"${path}"/link_1_file1 /tmp/"${path}"/link_1_1_file1
    rm /tmp/"${path}"/file1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    readlink /tmp/"${path}"/link_1_1_file | grep /tmp/"${path}"/link_1_file
    CHECK_RESULT $? 0 0 "cmd readlink error"
    readlink -e /tmp/"${path}"/link_1_1_file | grep /tmp/"${path}"/file
    CHECK_RESULT $? 0 0 "cmd readlink -e error"
    readlink -e /tmp/"${path}"/link_1_1_file1 | grep /tmp/"${path}"/file1
    CHECK_RESULT $? 0 1 "cmd readlink -e error"
    readlink -f /tmp/"${path}"/link_1_1_file1 | grep /tmp/"${path}"/file1
    CHECK_RESULT $? 0 0 "cmd readlink -f error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/"${path}"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
