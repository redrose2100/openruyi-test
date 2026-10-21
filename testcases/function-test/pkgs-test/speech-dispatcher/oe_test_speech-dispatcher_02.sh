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
    ### -t ###
    speech-dispatcher -t 30 | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    ### -P ###
    speech-dispatcher -P ./ | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -P No Pass"
    ### -C ###
    speech-dispatcher -C /etc/speech-dispatcher | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -C No Pass"
    ### -m ###
    speech-dispatcher -m ./ | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    ### -D ###
    rm -rf /tmp/speechd-debug
    speech-dispatcher -D | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -D No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
