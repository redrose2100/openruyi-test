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
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "netsniff-ng tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start to run test."
    localip=$(netstat -an|grep -v unix | grep "ESTABLISHED" | awk -F " " '{print $4}' | awk -F ":" '{print $1}' | sed -n '1p')
    astraceroute -v | grep "autonomous system trace route utility"
    CHECK_RESULT $? 0 0 "Check astraceroute -v failed"
    # test --version
    astraceroute --version | grep "autonomous system trace route utility"
    CHECK_RESULT $? 0 0 "Check astraceroute --version failed"
    astraceroute -h | grep "Usage: astraceroute"
    CHECK_RESULT $? 0 0 "Check astraceroute -h failed"
    # test --help
    astraceroute --help | grep "Usage: astraceroute"
    CHECK_RESULT $? 0 0 "Check astraceroute --help failed"
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org > tmp.txt &
    SLEEP_WAIT 5
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -H failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} --host netsniff-ng.org > tmp.txt &
    SLEEP_WAIT 5
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --host failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -p 80 > tmp.txt &
    SLEEP_WAIT 5
    grep "80 (netsniff-ng.org) with len" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -p failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --port 80 > tmp.txt &
    SLEEP_WAIT 7
    grep "80 (netsniff-ng.org) with len" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --port failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org > tmp.txt &
    SLEEP_WAIT 7
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -i failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -d ${NODE1_NIC} -H netsniff-ng.org > tmp.txt &
    SLEEP_WAIT 7
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -d failed"
    kill -9 $(pgrep -f "astraceroute -d")
    rm -f tmp.txt
    astraceroute --dev ${NODE1_NIC} -H netsniff-ng.org > tmp.txt &
    SLEEP_WAIT 7
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --dev failed"
    kill -9 $(pgrep -f "astraceroute --dev")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -b ${localip} > tmp.txt &
    SLEEP_WAIT 7
    grep "${localip}" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -b failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --bind ${localip} > tmp.txt &
    SLEEP_WAIT 7
    grep "${localip}" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --bind failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -f 17 > tmp.txt &
    SLEEP_WAIT 7
    grep "17:" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -f failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --init-ttl 17 > tmp.txt &
    SLEEP_WAIT 7
    grep "17:" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --init-ttl failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    LOG_INFO "End of the test."
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
