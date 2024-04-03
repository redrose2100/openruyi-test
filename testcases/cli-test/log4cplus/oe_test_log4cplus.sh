#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2022-04-11
# @License   :   Mulan PSL v2
# @Desc      :   package log4cplus test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "log4cplus* g++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    test -e /usr/include/log4cplus/
    CHECK_RESULT $? 0 0 "log4cplus path does not exist"
    ls -l /usr/lib64/liblog*
    CHECK_RESULT $? 0 0 "liblog path does not exist"
    g++ common/test1.cpp -I /usr/include/log4cplus/ -L /usr/lib64/ -llog4cplus -o test1
    ./test1
    CHECK_RESULT $? 0 0 "test1 execution failed"
    g++ common/test2.cpp -I /usr/include/log4cplus/ -L /usr/lib64/ -llog4cplus -o test2
    ./test2
    CHECK_RESULT $? 0 0 "test2 execution failed"
    cat < log.txt | grep Hello
    CHECK_RESULT $? 0 0 "Hello not found"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf log.txt test1 test2
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
