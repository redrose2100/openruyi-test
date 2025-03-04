#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023.01.13
# @License   :   Mulan PSL v2
# @Desc      :   File system common command readarray
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    echo {a..z} | tr " " "\n" >test.log
    CHECK_RESULT $? 0 0 "echo fail"
    readarray --help | grep -E "d 分隔符|d delim"
    CHECK_RESULT $? 0 0 "readarray help fail"
    readarray myarr<test.log
    CHECK_RESULT $? 0 0 "readarray fail"
    echo "${myarr[@]}" | grep -E "[a-z]"
    CHECK_RESULT $? 0 0 "Failure to Collect Information"
    readarray -n 6 myarr <test.log
    CHECK_RESULT $? 0 0 "readarray fail"
    echo "${myarr[@]}" | grep -E "[a-z]"
    CHECK_RESULT $? 0 0 "failed to test readarray -n 6"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    rm -rf test.log
    LOG_INFO "End to clean the test environment."
}

main "$@"

