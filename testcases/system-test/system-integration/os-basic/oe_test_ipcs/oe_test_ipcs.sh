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
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2024.3.6
# @License   :   Mulan PSL v2
# @Desc      :   ipcs formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ipcs |grep -E "Message Queues|消息队列"
    CHECK_RESULT $? 0 0 "ipcs default print error"
    ipcs |grep -E "Shared Memory Segments|共享内存段"
    CHECK_RESULT $? 0 0 "ipcs default print error"
    ipcs |grep -E "Semaphore Arrays|信号量数组"
    CHECK_RESULT $? 0 0 "ipcs default print error"
    ipcs -a |grep -E "消息队列|Message Queues"
    CHECK_RESULT $? 0 0 "ipcs -a execution failure"
    ipcs -all |grep -E "消息限制|Messages Limits"
    CHECK_RESULT $? 0 0 "ipcs -all execution failure"
    ipcs -m |grep -E "共享内存段|Shared Memory Segments"
    CHECK_RESULT $? 0 0 "ipcs -m execution failure"
    ipcs -h |grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "ipcs -h execution failure"
    ipcs -V |grep ipcs
    CHECK_RESULT $? 0 0 "ipcs -V execution failure"
    ipcs -q |grep -E "消息队列|Message Queues"
    CHECK_RESULT $? 0 0 "ipcs -q execution failure"
    ipcs -s |grep -E "信号量数组|Semaphore Arrays"
    CHECK_RESULT $? 0 0 "ipcs -s execution failure"
    ipcs -t |grep -E "消息队列|Message"
    CHECK_RESULT $? 0 0 "ipcs -r execution failure"
    ipcs -p |grep -E "PID"
    CHECK_RESULT $? 0 0 "ipcs -p execution failure"
    ipcs -c |grep -E "拥有者|Owners"
    CHECK_RESULT $? 0 0 "ipcs -c execution failure"
    ipcs -l |grep -E "同享内存限制|Shared Memory Limits"
    CHECK_RESULT $? 0 0 "ipcs -l execution failure"
    ipcs -u |grep -E "消息状态|Messages Status"
    CHECK_RESULT $? 0 0 "ipcs -u execution failure"
}

main "$@"

