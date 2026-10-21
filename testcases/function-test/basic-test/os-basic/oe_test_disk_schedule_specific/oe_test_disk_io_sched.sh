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
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023-03-20
# @License   :   Mulan PSL v2
# @Desc      :   package IO SCHED test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    disk=$(lsblk | awk 'NR==2' | awk '{print $1}')   
    old_scheduler=$(awk -F '[' '{print$2}' /sys/block/"${disk}"/queue/scheduler | awk -F ']' '{print$1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    sudo -i  echo none > /sys/block/${disk}/queue/scheduler    
    cat /sys/block/${disk}/queue/scheduler | grep "none"  
    CHECK_RESULT $? 0 0 "none is not selected by brackets"
    echo deadline > /sys/block/${disk}/queue/scheduler     
    cat /sys/block/${disk}/queue/scheduler | grep "mq-deadline"  
    CHECK_RESULT $? 0 0 "mq-deadline is not selected by brackets"
    echo bfq > /sys/block/${disk}/queue/scheduler     
    cat /sys/block/${disk}/queue/scheduler | grep "bfq"  
    CHECK_RESULT $? 0 0 "bfq is not selected by brackets"
    echo kyber > /sys/block/${disk}/queue/scheduler     
    cat /sys/block/${disk}/queue/scheduler | grep "kyber"  
    CHECK_RESULT $? 0 0 "kyber is not selected by brackets"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo "${old_scheduler}" >/sys/block/"${disk}"/queue/scheduler
    LOG_INFO "End to restore the test environment."
}

main $@
