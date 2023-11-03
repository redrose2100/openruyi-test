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
# @Desc      :   Test astraceroute
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
    # test -S
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -S > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:1,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -S failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --syn
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --syn > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:1,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --syn failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -A
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -A > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:1,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -A failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --ack
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --ack > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:1,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --ack failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -F
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -F > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:1,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -F failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --fin
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --fin > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:1,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --fin failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -P
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -P > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:1,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -P failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --psh
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --psh > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:1,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --psh failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -U
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -U > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:1" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -U failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --urg
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --urg > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:1" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --urg failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -R
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -R > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:1,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -R failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --rst
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --rst > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:1,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --rst failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -E
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -E > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:1,ACK:0,ECN:1,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -E failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --ecn-syn
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --ecn-syn > tmp.txt &
    SLEEP_WAIT 5
    grep "Using flags SYN:1,ACK:0,ECN:1,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --ecn-syn failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
