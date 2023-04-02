#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test ifpps
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    ifpps --dev ${NODE1_NIC}  --promisc -m > tmp.txt &
    SLEEP_WAIT 2
    kill -9 $(pgrep -f "ifpps --dev")
    grep  "med:" tmp.txt
    CHECK_RESULT $? 0 0 "Check ifpps -m failed"
    rm -f tmp.txt
    ifpps --dev ${NODE1_NIC}  --promisc --median > tmp.txt &
    SLEEP_WAIT 2
    kill -9 $(pgrep -f "ifpps --dev")
    grep  "med:" tmp.txt
    CHECK_RESULT $? 0 0 "Check ifpps --median failed"
    rm -f tmp.txt
    ifpps -c -d ${NODE1_NIC} -o | grep -e "[0-9]"
    CHECK_RESULT $? 0 0 "Check ifpps -o failed"
    ifpps -c -d ${NODE1_NIC} --omit-header | grep -e "[0-9]"
    CHECK_RESULT $? 0 0 "Check ifpps --omit-header failed"
    ifpps -c -d ${NODE1_NIC} -p | grep "gnuplot dump"
    CHECK_RESULT $? 0 0 "Check ifpps -p failed"
    ifpps -c -d ${NODE1_NIC} --promisc | grep "gnuplot dump"
    CHECK_RESULT $? 0 0 "Check ifpps --promisc failed"
    ifpps -c -d ${NODE1_NIC} -P | grep "gnuplot dump"
    CHECK_RESULT $? 0 0 "Check ifpps -P failed"
    ifpps -c -d ${NODE1_NIC} --percentage | grep "gnuplot dump"
    CHECK_RESULT $? 0 0 "Check ifpps --percentage failed"
    ifpps -d ${NODE1_NIC} -W -c | grep "gnuplot dump"
    CHECK_RESULT $? 0 0 "Check ifpps -W failed"
    ifpps -d ${NODE1_NIC} --no-warn -c | grep "gnuplot dump"
    CHECK_RESULT $? 0 0 "Check ifpps --no-warn failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
