#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-28
#@License   	:   Mulan PSL v2
#@Desc      	:   Check nic queue
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    test_nic=$(TEST_NIC 1)

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    qn=$(ethtool -l ${test_nic} | grep "Combined" | tail -n 1 | awk '{print $2}')
    if [[ $qn -lt 1 ]]; then
        CHECK_RESULT 1 0 0 "The queue of ${test_nic} is less than 1."
        exit 1
    fi
    ethtool -S ${test_nic} | grep "rx_queue" | grep -v "xdp" | grep "packets" | awk '{print $2}' >test_ori.log
    SLEEP_WAIT 10
    ethtool -S ${test_nic} | grep "rx_queue" | grep -v "xdp" | grep "packets" | awk '{print $2}' >test_cur.log

    for i in $(seq 1 $qn); do
        if [[ $(sed -n ${i}'p' test_ori.log) -gt $(sed -n ${i}'p' test_cur.log) ]]; then
            CHECK_RESULT 1 0 0 "Check ${i} rx_queue failed."

        fi
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f test_ori.log test_cur.log

    LOG_INFO "End to restore the test environment."
}

main "$@"
