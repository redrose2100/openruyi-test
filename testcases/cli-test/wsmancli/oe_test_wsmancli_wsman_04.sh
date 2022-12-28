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
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "wsmancli"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test command: wsman
    # SYNOPSIS: wsman [-? --help --help-all --help-enumeration --help-tests --help-cim --help-flags --help-event]
    # test option: -?
    wsman -? 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -?"
    # test option: --help
    wsman --help 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help"
    # test option: --help-all
    wsman --help-all 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-all"
    # test option: --help-enumeration
    wsman --help-enumeration 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-enumeration"
    # test option: --help-tests
    wsman --help-tests 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-tests"
    # test option: --help-cim
    wsman --help-cim 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-cim"
    # test option: --help-flags
    wsman --help-flags 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-flags"
    # test option: --help-event
    wsman --help-event 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-event"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
