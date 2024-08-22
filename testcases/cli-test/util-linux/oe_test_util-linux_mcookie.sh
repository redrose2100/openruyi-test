#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-07-31
# @License   :   Mulan PSL v2
# @Desc      :   Command test-mcookie
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    mcookie|grep  '[0-9]'
    CHECK_RESULT $? 0 0 "description failed to view the dc version"
    echo 111 > test2
    CHECK_RESULT $? 0 0 "failed to create file"
    mcookie -m 4 -f  test2 |grep '[0-9]'
    CHECK_RESULT $? 0 0 "specifying file execution size to make cookie seed failed"
    mcookie -v  > test1  2>&1
    CHECK_RESULT $? 0 0 "explanation An ongoing operation failed"
    grep "Got" test1
    CHECK_RESULT $? 0 0 "the corresponding field was not obtained"
    mcookie -V|grep util-linux
    CHECK_RESULT $? 0 0 "failed to check version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf test1 test2
    LOG_INFO "End to clean the test environment."
}

main "$@"
