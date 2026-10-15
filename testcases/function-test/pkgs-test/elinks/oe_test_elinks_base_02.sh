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
# @Desc      :   verify the uasge of elinks command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL elinks
    echo > text
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    elinks -dump text -dump-color-mode 1 www.baidu.com | grep "https://zhidao.baidu.com"
    CHECK_RESULT $? 0 0 "Check elinks -dump -dump-color-mode failed"

    elinks -dump text -dump-width 1 www.baidu.com | grep "http://wenku.baidu.com"
    CHECK_RESULT $? 0 0 "Check elinks -dump -dump-width failed"

    elinks -eval text www.baidu.com | grep "http://www.baidu.com/content-search"
    CHECK_RESULT $? 0 0 "Check elinks -eval failed"

    elinks --help | grep -F "Usage: elinks [OPTION]"
    CHECK_RESULT $? 0 0 "Check elinks --help failed"

    elinks -h | grep -F "Usage: elinks [OPTION]"
    CHECK_RESULT $? 0 0 "Check elinks -h failed"

    elinks -version | grep "ELinks [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check elinks -version failed"

    nohup elinks -localhost 0 www.baidu.com >./info.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info.log
    CHECK_RESULT $? 0 0 "Check elinks -localhost failed"

    elinks -long-help 2>&1 | grep "Usage: elinks"
    CHECK_RESULT $? 0 0 "Check elinks -long-help failed"

    elinks -lookup www.baidu.com | grep -o -E "[0-9.]+"
    CHECK_RESULT $? 0 0 "Check elinks -lookup failed"

    nohup elinks -no-connect www.baidu.com >./info1.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info1.log
    CHECK_RESULT $? 0 0 "Check elinks -no-connect failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf -- *.log text
    LOG_INFO "Finish restore the test environment."
}

main "$@"
