#!/usr/sbin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-11-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of /sbin
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    cur_lang="${LANG}"
    export LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    [[ "$(readlink /sbin)" == "usr/sbin" ]]
    CHECK_RESULT $? 0 0 "/sbin is not soft link of /usr/sbin "
    diff /sbin /usr/sbin
    CHECK_RESULT $? 0 0 "The /sbin doesn't same with /usr/sbin."
    actual_access=$(find /usr/sbin -mindepth 1 -maxdepth 1 -exec stat -c '%A' {} \; | sort | uniq)
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        expect_file="./expect_access_riscv64"
    else
        expect_file="./expect_access"
    fi
    while read -r rows; do
        if [[ $actual_access =~ $rows ]]; then 
            continue
        fi
        CHECK_RESULT 1 0 0 "The access of file under /sbin is error."
        break
    done < "$expect_file"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

