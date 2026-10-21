#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2023/04/04
# @License   :   Mulan PSL v2
# @Desc      :   Test xmllint format xml
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dmraid
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dmraid -h |grep dmraid
    CHECK_RESULT $? 0 0 "failed to dmraid help"
    dmraid -V |grep "1.0.0.rc16"
    CHECK_RESULT $? 0 0 "Failed to version "
    if [ "$(dmraid -s)" == 0  ]; then
      dmraid -n |grep devs
      CHECK_RESULT $? 0 0 "Failed to raid "
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
