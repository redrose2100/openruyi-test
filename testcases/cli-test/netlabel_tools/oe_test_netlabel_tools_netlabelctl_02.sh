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
# @Desc      :   verify the uasge of nasm command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL netlabel_tools
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test"

    netlabelctl cipsov4 add pass doi:16 tags:1
    CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 add pass failed"
    netlabelctl cipsov4 del doi:16
    CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 del failed"
    netlabelctl cipsov4 add trans doi:8 tags:1 levels:0=0,1=1 categories:0=1,1=0
    CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 add trans doi:8 tags:1 levels:0=0,1=1 categories:0=1,1=0 failed"
    netlabelctl cipsov4 del doi:8
    CHECK_RESULT $? 0 0 "Check cipsov4 del failed"
    netlabelctl cipsov4 add local doi:9
    CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 add local failed"
    netlabelctl cipsov4 del doi:9
    CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 del failed"
    netlabelctl -p cipsov4 list 2>&1 | grep 'Configured'
    CHECK_RESULT $? 0 0 "Check netlabelctl -p cipsov4 list failed"
    netlabelctl cipso add pass doi:16 tags:1
    CHECK_RESULT $? 0 0 "Check netlabelctl cipso add failed"
    netlabelctl -p cipso list -v -t 10 2>&1 | grep 'Configured CIPSO'
    CHECK_RESULT $? 0 0 "Check netlabelctl -p cipso -v -t failed"
    netlabelctl cipso del doi:16
    CHECK_RESULT $? 0 0 "Check netlabelctl cipso del failed"

    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    netlabelctl calipso del doi:11
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
