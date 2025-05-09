#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Check ss
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ss | grep "State"
    CHECK_RESULT $? 0 0 "Check ss failed."
    ss -o |grep "timer"
    CHECK_RESULT $? 0 0 "Check ss -o failed."
    ss -m |grep "skmem"
    CHECK_RESULT $? 0 0 "Check ss -m failed."
    ss -p |grep "pid"
    CHECK_RESULT $? 0 0 "Check ss -p failed."
    ss -t state established
    CHECK_RESULT $? 0 0 "Check ss -t state established failed."
    ss -t state listening
    CHECK_RESULT $? 0 0 "Check ss -t state listening failed."
    ss -t sport = :22
    CHECK_RESULT $? 0 0 "Check ss -t sport failed."
    ss -t dport = :80
    CHECK_RESULT $? 0 0 "Check ss -t dport failed."
    ss -4 -t
    CHECK_RESULT $? 0 0 "Check ss -4 -t failed."
    ss -6 -t  
    CHECK_RESULT $? 0 0 "Check ss -6 -t failed."
    LOG_INFO "End to run test."
}


main "$@"
