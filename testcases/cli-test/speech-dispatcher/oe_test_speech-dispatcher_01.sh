#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/9/15
#@License   :   Mulan PSL v2
#@Desc      :   Test "speech-dispatcher" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "speech-dispatcher"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_pyjunitxml."
    ### -h ###
    speech-dispatcher -h | grep "Usage: speech-dispatcher"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -v ###
    speech-dispatcher -v | grep "speech-dispatcher"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    ### -d ###
    speech-dispatcher -d | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
    ### -s ###
    speech-dispatcher -s | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    ### -a ###
    speech-dispatcher -a | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
    ### -l ###
    speech-dispatcher -l 1 | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -L ###
    speech-dispatcher -L ./ | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
    ### -c ###
    speech-dispatcher -c unix_socket | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    ### -S ###
    speech-dispatcher -S default | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
    ### -p ###
    speech-dispatcher -p 789 | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
