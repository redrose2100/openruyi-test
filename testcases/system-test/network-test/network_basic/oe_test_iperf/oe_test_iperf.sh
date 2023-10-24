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
#@Date      	:   2021-08-05
#@License   	:   Mulan PSL v2
#@Desc      	:   Check iperf3
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL iperf3
    DNF_INSTALL iperf3 2
    SSH_CMD "systemctl stop firewalld" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    SSH_CMD "echo q | nohup iperf3 -s &" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Start iperf3 tcp server failed."
    iperf3 -c ${NODE2_IPV4} -P 10 -t 60
    CHECK_RESULT $? 0 0 "Check tcp failed."

    SSH_CMD "echo q | nohup iperf3 -s -u &" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Start iperf3 udp server failed."
    iperf3 -u -c ${NODE2_IPV4} -P 10 -t 60
    CHECK_RESULT $? 0 0 "Check udp failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    SSH_CMD " kill -9 $(ps -ef | grep iperf3 | grep -Ev 'grep|bash')" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "systemctl restart firewalld" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
