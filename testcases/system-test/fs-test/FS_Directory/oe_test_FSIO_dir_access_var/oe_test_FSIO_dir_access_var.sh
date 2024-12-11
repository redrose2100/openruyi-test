#!/usr/bin/bash

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
#@Desc      	:   Take the test access of /var
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    cur_lang="$LANG"
    export LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    actual_name=$(ls /var)
    while read -r rows; do
        if [[ $actual_name =~ $rows ]]; then 
            continue
        fi
	if uname -a | grep -q "riscv64"; then
	    if [[ $rows = "crash" ]]; then
		    continue	
	    fi
	fi
	CHECK_RESULT 1 0 0 "The file under /var is error."
        break
    done <./expect_name
    actual_access=$(find /var -maxdepth 1  ! -name "." ! -name ".." ! -name ".*"  ! -name "named" -exec stat -c "%A" {} + | grep -Ev "^total$" | sort | uniq)
    while read rows; do
        if [[ $actual_access =~ $rows ]]; then 
            continue
        fi
        CHECK_RESULT 1 0 0 "The access of file under /var is error."
        break
    done <./expect_access
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

