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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL elinks
    echo > text
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    nohup elinks -force-html www.baidu.com >./info.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info.log
    CHECK_RESULT $? 0 0 "Check nohup elinks -force-html failed"

    nohup elinks -no-home www.baidu.com >./info1.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info1.log
    CHECK_RESULT $? 0 0 "Check elinks -no-home failed"

    nohup elinks -no-numbering www.baidu.com >./info2.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info2.log
    CHECK_RESULT $? 0 0 "Check elinks -no-numbering failed"

    nohup elinks -no-references www.baidu.com >./info3.log 2>&1 &
    SLEEP_WAIT 2
    grep -F  "百度搜索" ./info3.log
    CHECK_RESULT $? 0 0 "Check elinks -no-references failed"

    elinks -remote text -dump www.baidu.com | grep "http://www.beian.gov.cn/portal"
    CHECK_RESULT $? 0 0 "Check elinks -remote -dump failed"

    nohup elinks -session-ring 1 www.baidu.com >./info4.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info4.log
    CHECK_RESULT $? 0 0 "Check elinks -session-ring failed"

    elinks -source 1 www.baidu.com | grep "var hasClicked"
    CHECK_RESULT $? 0 0 "Check elinks -source failed"

    nohup elinks -touch-files www.baidu.com >./info5.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info5.log
    CHECK_RESULT $? 0 0 "Check elinks -touch-files failed"

    nohup elinks -verbose 1 www.baidu.com >./info6.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info6.log
    CHECK_RESULT $? 0 0 "Check elinks -verbose failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf -- *.log text
    LOG_INFO "Finish restore the test environment."
}

main "$@"
