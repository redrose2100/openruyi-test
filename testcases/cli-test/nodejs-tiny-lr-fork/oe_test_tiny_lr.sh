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
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test tiny-lr
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nodejs-tiny-lr-fork
    versionnum=$(rpm -q nodejs-tiny-lr-fork | awk -F '-' '{print $5}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    tiny-lr -v ${versionnum}
    CHECK_RESULT $? 0 0 "Check tiny-lr -V failed"
    tiny-lr --version ${versionnum}
    CHECK_RESULT $? 0 0 "Check tiny-lr --version failed"
    tiny-lr -p 25555 > port.info &
    SLEEP_WAIT 1
    grep "Listening on 25555" port.info
    CHECK_RESULT $? 0 0 "Check tiny-lr -p failed"
    tiny-lr --port 26666 > port.info &
    SLEEP_WAIT 1
    grep "Listening on 26666" port.info
    CHECK_RESULT $? 0 0 "Check tiny-lr --port failed"
    tiny-lr --pid pid.info &
    SLEEP_WAIT 1
    grep -e "^[0-9].*[0-9]$" pid.info
    CHECK_RESULT $? 0 0 "Check tiny-lr --pid failed"
    update-livereload
    CHECK_RESULT $? 0 0 "Check update-livereload failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f *.info *.pid
    kill -9 $(ps -ef | grep -v grep | grep -v nodejs-tiny-lr-fork | grep tiny-lr | awk '{print $2}')
    LOG_INFO "End to restore the test environment."
}

main "$@"
