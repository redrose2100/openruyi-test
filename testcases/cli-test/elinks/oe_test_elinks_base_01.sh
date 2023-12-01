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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL elinks
    echo > text
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    nohup elinks -anonymous www.baidu.com >./info.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info.log
    CHECK_RESULT $? 0 0 "Check elinks -anonymous failed"

    nohup elinks -auto-submit www.baidu.com >./info1.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info.log
    CHECK_RESULT $? 0 0 "Check elinks -auto-submit failed"

    elinks -dump www.baidu.com -base-session 1 | grep "http://www.baidu.com"
    CHECK_RESULT $? 0 0 "Check elinks -dump -base-session failed"

    nohup elinks -config-dir text www.baidu.com >./info2.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info2.log
    CHECK_RESULT $? 0 0 "Check elinks -config-dir failed"

    elinks -config-dump www.baidu.com | grep "set ui.success_msgbox"
    CHECK_RESULT $? 0 0 "Check elinks -config-dump failed"

    nohup elinks -config-file text www.baidu.com >./info3.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info3.log
    CHECK_RESULT $? 0 0 "Check elinks -config-file failed"

    elinks -config-help | grep "ui.timer.duration"
    CHECK_RESULT $? 0 0 "Check elinks -config-help failed"

    nohup elinks -default-mime-type text www.baidu.com >./info4.log 2>&1 &
    SLEEP_WAIT 2
    grep "http://wenku.baidu.com/search" ./info4.log
    CHECK_RESULT $? 0 0 "Check elinks -default-mime-type failed"

    elinks -default-keys -dump www.baidu.com | grep "https://top.baidu.com/board"
    CHECK_RESULT $? 0 0 "Check elinks -default-keys -dump www.baidu.com failed"

    elinks -dump www.baidu.com -dump-charset utf-8 | grep "http://image.baidu.com"
    CHECK_RESULT $? 0 0 "Check elinks -dump -dump-charset failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf *.log text
    LOG_INFO "Finish restore the test environment."
}

main "$@"
