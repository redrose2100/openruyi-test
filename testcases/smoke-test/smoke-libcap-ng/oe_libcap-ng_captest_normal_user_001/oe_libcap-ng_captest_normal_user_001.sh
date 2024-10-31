#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   captest添加capabilities，普通用户执行captest。
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
testuser=user"$RANDOM"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which captest || DNF_INSTALL "libcap-ng libcap-ng-utils"
    path=$(which captest)
    useradd "$testuser"
    captest_default_cap=$(filecap "$path")
    test -z "$captest_default_cap" 
    CHECK_RESULT $? 0 0 "Check captest_default_cap failed"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    #普通用户执行captest
    su - "$testuser" -c captest | grep -E "^Current capabilities: none$"
    CHECK_RESULT $? 0 0 "Check Current capabilities failed"
    su - "$testuser" -c captest | grep -E "^Child capabilities: none$"
    CHECK_RESULT $? 0 0 "Check Child capabilities failed"

    #为captest命令添加chown特权
    filecap "$path" chown
    result=$(filecap "$path" | awk 'NR==2 {print $NF}')
    [[ "$result" = "chown" ]] 
    CHECK_RESULT $? 0 0 "Check filecap failed"

    #普通用户再次执行captest
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Effective"
    CHECK_RESULT $? 0 0  "Check Effective failed"
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Permitted"
    CHECK_RESULT $? 0 0  "Check Permitted failed"
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Inheritable"
    CHECK_RESULT $? 0 0  "Check Inheritable failed"
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Bounding Set"
    CHECK_RESULT $? 0 0  "Check Bounding Set failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    filecap "$path" none
    userdel -r "$testuser"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"