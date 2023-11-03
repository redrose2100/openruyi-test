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
    # test -v
    ifpps -v | grep "ifpps"
    CHECK_RESULT $? 0 0 "Check ifpps -v failed"
    # test --version
    ifpps --version | grep "ifpps"
    CHECK_RESULT $? 0 0 "Check ifpps --version failed"
    # test -h
    ifpps -h | grep "Usage: ifpps"
    CHECK_RESULT $? 0 0 "Check ifpps -g failed"
    # test --help
    ifpps --help | grep "Usage: ifpps"
    CHECK_RESULT $? 0 0 "Check ifpps --help failed"
    # test -d
    ifpps -c -d ${NODE1_NIC} | grep "networking interface: ${NODE1_NIC}"
    CHECK_RESULT $? 0 0 "Check ifpps -d failed"
    # test --dev
    ifpps -c --dev ${NODE1_NIC} | grep "networking interface: ${NODE1_NIC}"
    CHECK_RESULT $? 0 0 "Check ifpps --dev failed"
    # test -t
    ifpps -c --dev ${NODE1_NIC} -t 500 | grep "sampling interval (t): 500 ms"
    CHECK_RESULT $? 0 0 "Check ifpps -t failed"
    # test --interval
    ifpps -c --dev ${NODE1_NIC} --interval 500 | grep "sampling interval (t): 500 ms"
    CHECK_RESULT $? 0 0 "Check ifpps --interval failed"
    # test -c
    ifpps -pcd ${NODE1_NIC} > tmp.data
    grep "gnuplot dump" tmp.data
    CHECK_RESULT $? 0 0 "Check ifpps -c failed"
    rm -f tmp.data
    # test --csv
    ifpps -pd ${NODE1_NIC} --csv > tmp.data
    grep "gnuplot dump" tmp.data
    CHECK_RESULT $? 0 0 "Check ifpps --csv failed"
    rm -f tmp.data
    # test -l
    ifpps -lpcd ${NODE1_NIC} > plot.dat &
    SLEEP_WAIT 2
    kill -9 $(pgrep -f "ifpps -lpcd")
    grep  "networking interface: ${NODE1_NIC}" plot.dat
    CHECK_RESULT $? 0 0 "Check ifpps -l failed"
    rm -f plot.dat
    # test --loop
    ifpps --loop -pcd ${NODE1_NIC} > plot.dat &
    SLEEP_WAIT 2
    kill -9 $(pgrep -f "ifpps --loop -pcd")
    grep  "networking interface: ${NODE1_NIC}" plot.dat
    CHECK_RESULT $? 0 0 "Check ifpps --loop failed"
    rm -f plot.dat
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
