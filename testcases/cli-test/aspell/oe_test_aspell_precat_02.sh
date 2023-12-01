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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of aspell command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL aspell
    cp ./common/1.txt.pz ./
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    precat -f -c -k 1.txt.pz | grep "aaa"
    CHECK_RESULT $? 0 0 "Check precat -f -c -k failed"

    precat --force --stdout --keep 1.txt.pz | grep "aaa"
    CHECK_RESULT $? 0 0 "Check precat --force --stdout --keep failed"

    precat -q -S -s 1.txt.pz | grep "eee"
    CHECK_RESULT $? 0 0 "Check precat -q -S -s failed"

    precat --quiet --nocwl --sort 1.txt.pz | grep "eee"
    CHECK_RESULT $? 0 0 "Check precat --quiet --nocwl --sort failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf 1.txt.pz
    LOG_INFO "End to restore the test environment."
}

main "$@"
