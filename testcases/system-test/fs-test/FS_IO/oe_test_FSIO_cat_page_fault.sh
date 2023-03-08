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
#@Date      	:   2021-04-29
#@License   	:   Mulan PSL v2
#@Desc      	:   Cat process to check its page fault
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    pid=$(ps -ef | grep systemd | awk '{print $2}' | head -n 1)
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat /proc/${pid}/stat
    CHECK_RESULT $? 0 0 "Check page for ${pid} failed."
    ps -o majflt,minflt -C bash
    CHECK_RESULT $? 0 0 "Verify page for bash failed."
    LOG_INFO "End to run test."
}


main "$@"

