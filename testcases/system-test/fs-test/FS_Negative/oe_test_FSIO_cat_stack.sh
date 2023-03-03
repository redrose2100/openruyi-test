#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2021-03-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test cat process stack
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    size1=$(free -m | grep Mem | awk '{print $ 4}')
    for i in {1..1000}; do 
        cat /proc/1/stack >/dev/null
    done
    status=$(ps -aux | grep 1 | head -n 1 | awk '{print $8}')
    [[ $status =~ 'Z' || $status =~ 'X' ]] 
    CHECK_RESULT $? 1 0 "Cat process 1's stack caused process Z/X"
    LOG_INFO "End to run test."
}

main "$@"
