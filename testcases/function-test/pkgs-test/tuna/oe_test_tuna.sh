#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/01/02
# @License   :   Mulan PSL v2
# @Desc      :   Test "tuna" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "tuna"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    tuna -h | grep "usage: tuna"
    CHECK_RESULT $? 0 0 "tuna -h No Pass"
    tuna --help | grep "usage: tuna"
    CHECK_RESULT $? 0 0 "tuna --help No Pass"
    tuna -v | grep "$(rpm -qa tuna | awk -F- '{print $2}')"
    CHECK_RESULT $? 0 0 "tuna -v No Pass"
    tuna --version | grep "$(rpm -qa tuna | awk -F- '{print $2}')"
    CHECK_RESULT $? 0 0 "tuna --version No Pass"
    tuna -D 2>&1 | grep -i "debug"
    CHECK_RESULT $? 0 0 "tuna -D No Pass"
    tuna -D -L 1 2>&1 | grep "log level"
    CHECK_RESULT $? 0 0 "tuna -L No Pass"
    tuna --debug 2>&1 | grep -i "debug"
    CHECK_RESULT $? 0 0 "tuna --debug No Pass"
    tuna -D --logging 1 2>&1 | grep "log level"
    CHECK_RESULT $? 0 0 "tuna --logging No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./tuna-*
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
