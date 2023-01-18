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
# @Desc      :   verify the uasge of openjade command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openjade
    cp common/*.sgml ./
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    openjade -b utf-8 -D ./ common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -D failed"
    openjade -b utf-8 --directory ./ common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade  --directory failed"

    openjade -b utf-8 -D ./ -R -s ./null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -R  failed"
    openjade -b utf-8 -D ./ --restricted -s ./null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --restricted failed"

    openjade -b utf-8 -a test common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -a failed"
    openjade -b utf-8 --activate test common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --activate failed"
    openjade -b utf-8 -A TEST common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -A failed"
    openjade -b utf-8 --architecture TEST common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --architecture failed"
    openjade -b utf-8 -E 1 common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -E failed"
    openjade -b utf-8 --max-errors 1 common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --max-errors failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf *.sgml error.* common/*.rtf common/*.fot common/*.xml common/error.*
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
