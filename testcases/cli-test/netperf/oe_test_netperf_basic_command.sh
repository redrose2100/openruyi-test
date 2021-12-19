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
#@Desc          :   netperf basic command line test 
####################################
source "./common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    netperf -H "$NODE2_IPV4" -p ${rdport} | grep "Throughput"
    CHECK_RESULT $? 0 0 "netperf -H execution failed."
    netperf -H "$NODE2_IPV4" -p ${rdport} -f M | grep "MBytes/sec"
    CHECK_RESULT $? 0 0 "netperf -f M execution failed."
	netperf -H "$NODE2_IPV4" -p ${rdport} -l 5 | grep " 5."
    CHECK_RESULT $? 0 0 "netperf -l 5 execution failed."
	netperf -H "$NODE2_IPV4" -p ${rdport} -t UDP_STREAM -- -m 1024 | grep "1024"
    CHECK_RESULT $? 0 0 "netperf -m 1024 execution failed."
	netperf -H "$NODE2_IPV4" -p ${rdport} -P 0 -- -m 1024 | grep "MIGRATED"
    CHECK_RESULT $? 0 1 "netperf -P 0 execution failed."
	netperf -H "$NODE2_IPV4" -p ${rdport} -O "MIN_LAETENCY,MAX_LATENCY,MEAN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT,THROUGHPUT_UNITS" | grep "sec"
	CHECK_RESULT $? 0 0 "netperf -O with different options execution failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_env
    LOG_INFO "End to restore the test environment."
}

main "$@"