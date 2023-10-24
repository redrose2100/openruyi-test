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
#@Date      	:   2021-08-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Check traceroute
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL traceroute
    dd if=/dev/zero of=testFile bs=50M count=1

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    traceroute -4 ${NODE2_IPV4} | tee traceroute.log &
    CHECK_RESULT $? 0 0 "Check traceroute failed."
    SSH_SCP testFile ${NODE2_USER}@${NODE2_IPV4}:/opt ${NODE2_PASSWORD}
    CHECK_RESULT $? 0 0 "scp file to node2 failed."
    grep ${NODE2_IPV4} traceroute.log
    CHECK_RESULT $? 0 0 "Check traceroute log failed."
    SSH_CMD "test -f /opt/testFile" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "The file doesn't exist in node2."

    traceroute -m 10 www.baidu.com
    CHECK_RESULT $? 0 0 "Check traceroute url failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f testFile traceroute.log
    SSH_CMD "rm -f /opt/testFile" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
