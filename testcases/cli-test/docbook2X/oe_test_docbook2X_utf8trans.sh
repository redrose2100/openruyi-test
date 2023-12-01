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
# @Desc      :   verify the uasge of docbook2X command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL docbook2X
    echo aaa bbb >1.txt
    echo aaa >2.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    utf8trans -m 1.txt 2.txt
    CHECK_RESULT $? 0 0 "Check utf8trans -m failed"

    utf8trans --modify 1.txt 2.txt
    CHECK_RESULT $? 0 0 "Check utf8trans --modify failed"

    utf8trans -v | grep "utf8trans (part of docbook2X[[:digit:]].*)"
    CHECK_RESULT $? 0 0 "Check utf8trans -v failed"

    utf8trans --version | grep "utf8trans (part of docbook2X[[:digit:]].*)"
    CHECK_RESULT $? 0 0 "Check utf8trans --version failed"

    utf8trans -h | grep "Usage: utf8trans"
    CHECK_RESULT $? 0 0 "Check utf8trans -h failed"

    utf8trans --help | grep "Usage: utf8trans"
    CHECK_RESULT $? 0 0 "Check utf8trans --help failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf 1.txt 2.txt
    LOG_INFO "Finish restore the test environment."
}

main "$@"
