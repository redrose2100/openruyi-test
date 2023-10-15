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
#@Date      	:   2021-06-24
#@License   	:   Mulan PSL v2
#@Desc      	:   Close swap temporary
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    swapoff -a
    off_swap=$(free -m | grep -i "swap" | awk '{print $4}')
    echo "off_swap = $off_swap"
    SLEEP_WAIT 10
    swapon -a
    on_swap=$(free -m | grep -i "swap" | awk '{print $4}')
    echo "on_swap = $on_swap"
    [[ $off_swap -eq "0" && $on_swap -ne "0" ]]
    CHECK_RESULT $? 0 0 "Close and open swap temporary succeed."
    LOG_INFO "End to run test."
}

main "$@"

