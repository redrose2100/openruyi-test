#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangliang
#@Contact   	:   wangliang4@uniontech.com
#@Date      	:   2024-06-04
#@License   	:   Mulan PSL v2
#@Desc      	:   test export
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    key="Test function" 
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    func () { echo "$key"; } && export -f func
    ret=$(func)
    test "${ret}" == "${key}"
    CHECK_RESULT $? 0 0 "test argrument -f failure"
    export -p | grep  "declare"
    CHECK_RESULT $? 0 0 "test argrument -p failure"
    export LinuxOS="$key"
    ret=$(env | grep -i "$key")
    test "${ret}" == "LinuxOS=${key}"
    CHECK_RESULT $? 0 0 "test env set failure"
    export -n LinuxOS
    ret=$(export | grep -i "$key")
    test "${ret}" == ""
    CHECK_RESULT $? 0 0 "test argrument -n failure"
    LOG_INFO "Finish test."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    unset key
    unset func
    unset ret
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring environment."
}

main "$@"
