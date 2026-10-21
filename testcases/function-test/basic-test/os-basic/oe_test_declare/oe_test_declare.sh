#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   杨元淦
#@Contact       :   yangyuangan@uniontech.com
#@Date          :   2026/5/12
#@License       :   Mulan PSL v2
#@Desc          :   bash declare typed variables and integer arithmetic
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."

    # declare -i integer arithmetic (auto-eval)
    declare -i count=5
    count+=3
    test $count -eq 8
    CHECK_RESULT $? 0 0 "declare -i addition failed"

    # declare -i protects against string assignment
    declare -i age=10
    age="hello" >/dev/null 2>&1
    test $age -eq 0
    CHECK_RESULT $? 0 0 "declare -i string-to-int should be 0"

    # declare -a indexed array
    declare -a colors=(red green blue)
    test "${colors[0]}" = "red"
    CHECK_RESULT $? 0 0 "declare -a index 0 failed"
    test "${colors[2]}" = "blue"
    CHECK_RESULT $? 0 0 "declare -a index 2 failed"
    test ${#colors[@]} -eq 3
    CHECK_RESULT $? 0 0 "declare -a array length failed"

    # declare -A associative array
    declare -A server_info
    server_info[hostname]="web01"
    server_info[ip]="10.0.0.1"
    test "${server_info[hostname]}" = "web01"
    CHECK_RESULT $? 0 0 "declare -A hostname lookup failed"
    test "${server_info[ip]}" = "10.0.0.1"
    CHECK_RESULT $? 0 0 "declare -A ip lookup failed"

    # declare -r readonly variable (test value read, skip modification — bash aborts on readonly assign)
    declare -r readonly_var="immutable"
    test "$readonly_var" = "immutable"
    CHECK_RESULT $? 0 0 "declare -r read failed"
    # verify declare -p shows readonly flag
    declare -p readonly_var 2>&1 | grep -q "\-r"
    CHECK_RESULT $? 0 0 "declare -r should show -r attribute"

    # declare -l lowercase
    declare -l lc="HELLO"
    test "$lc" = "hello"
    CHECK_RESULT $? 0 0 "declare -l lowercase failed"

    # declare -u uppercase
    declare -u uc="hello"
    test "$uc" = "HELLO"
    CHECK_RESULT $? 0 0 "declare -u uppercase failed"

    # declare -x export simultaneously
    declare -x shared_var="visible"
    bash -c 'test "$shared_var" = "visible"'
    CHECK_RESULT $? 0 0 "declare -x export failed"

    LOG_INFO "Finish test!"
}

main "$@"

