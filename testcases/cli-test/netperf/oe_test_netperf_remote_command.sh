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
#@Author        :   hejinjin
#@Contact       :   jinjin@isrc.iscas.ac.cn
#@Date          :   2021/12/19
#@License       :   Mulan PSL v2
#@Desc          :   netperf test remote command-netserver
####################################
source "./common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "netperf"
    DNF_INSTALL "netperf" 2
    rdport=$(GET_FREE_PORT "$NODE2_IPV4")
    P_SSH_CMD --cmd "systemctl stop firewalld"
	
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

	P_SSH_CMD --cmd "netserver -V" | grep "version"
    CHECK_RESULT $? 0 0 "netserver -V failed."

	P_SSH_CMD --cmd "netserver -d -p ${rdport}" | grep "check_if_inetd"
    CHECK_RESULT $? 0 0 "netserver -d failed."
	P_SSH_CMD --cmd "kill -9 \$(ps -ef | grep netserver | grep -v grep | awk '{print \$2}')"
	SLEEP_WAIT 2

	P_SSH_CMD --cmd "netserver -f -N -v 2 -p ${rdport}" | grep "netserver"
    CHECK_RESULT $? 0 0 "netserver -f -N -v 2 failed."
	P_SSH_CMD --cmd "kill -9 \$(ps -ef | grep netserver | grep -v grep | awk '{print \$2}')"
	SLEEP_WAIT 2

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_env
    LOG_INFO "End to restore the test environment."
}

main "$@"