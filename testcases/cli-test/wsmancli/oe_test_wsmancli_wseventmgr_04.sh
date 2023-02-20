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
# @Author    :   chenzirui
# @Contact   :   ziruichen@126.com
# @Date      :   2022/10/01
# @License   :   Mulan PSL v2
# @Desc      :   Test wsmancli
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "wsmancli"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test command: wseventmgr
    # SYNOPSIS: wseventmgr [-? --help --help-all --help-event]
    # test option: -?
    wseventmgr -? 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -?"
    # test option: --help
    wseventmgr --help 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --help"
    # test option: --help-all
    wseventmgr --help-all 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --help-all"
    # test option: --help-event
    wseventmgr --help-event 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --help-event"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
