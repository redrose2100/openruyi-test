#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   hourui
# @Contact   :   867559702@qq.com
# @Date      :   2022/8/05
# @License   :   Mulan PSL v2
# @Desc      :   Test "beakerlib" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "beakerlib"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    [[ "$(beakerlib-lsb_release -v)" =~  "LSB Version:" ]]
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -v failed!"
    [[ "$(beakerlib-lsb_release -i)" =~  "Distributor ID:" ]]
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -i failed!"
    [[ "$(beakerlib-lsb_release -d)" =~  "Description:" ]]
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -d failed!"
    [[ "$(beakerlib-lsb_release -r)" =~  "Release:" ]]
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -r failed!"
    [[ "$(beakerlib-lsb_release -c)" =~  "Codename:" ]]
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -c failed!"
    beakerlib-lsb_release -s
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -s failed!"
    beakerlib-lsb_release -a
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -a failed!"
    beakerlib-lsb_release -h | grep 'Usage'
    CHECK_RESULT $? 0 0 "beakerlib-lsb_release -h failed!"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"