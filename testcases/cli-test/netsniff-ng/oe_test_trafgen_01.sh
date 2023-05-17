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
# @Desc      :   Test trafgen
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
    trafgen -h | grep "Usage: trafgen"
    CHECK_RESULT $? 0 0 "Check trafgen -h failed"
    trafgen --help | grep "Usage: trafgen"
    CHECK_RESULT $? 0 0 "Check trafgen --help failed"
    trafgen -v | grep "trafgen 0.6.8"
    CHECK_RESULT $? 0 0 "Check trafgen -v failed"
    trafgen --version | grep "trafgen 0.6.8"
    CHECK_RESULT $? 0 0 "Check trafgen --version failed"
    trafgen -e | grep "Data blob"
    CHECK_RESULT $? 0 0 "Check trafgen -e failed"
    trafgen --example | grep "Data blob"
    CHECK_RESULT $? 0 0 "Check trafgen --example failed"
    netsniff-ng --in ${NODE1_NIC} --out tcpsyn.pcap -n 2
    netsniff-ng --in tcpsyn.pcap --out tcpsyn.cfg -n 2
    trafgen --in tcpsyn.cfg --out ${NODE1_NIC} --num 1000 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen --in failed"
    rm -f tcpsyn.pcap tcpsyn.cfg
    netsniff-ng --in ${NODE1_NIC} --out tcpsyn.pcap -n 2
    netsniff-ng --in tcpsyn.pcap --out tcpsyn.cfg -n 2
    trafgen -i tcpsyn.cfg --out ${NODE1_NIC} --num 1000 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen -i failed"
    rm -f tcpsyn.pcap tcpsyn.cfg
    netsniff-ng --in ${NODE1_NIC} --out tcpsyn.pcap -n 2
    netsniff-ng --in tcpsyn.pcap --out tcpsyn.cfg -n 2
    trafgen -c tcpsyn.cfg --out ${NODE1_NIC} --num 1000 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen -c failed"
    rm -f tcpsyn.pcap tcpsyn.cfg
    netsniff-ng --in ${NODE1_NIC} --out tcpsyn.pcap -n 2
    netsniff-ng --in tcpsyn.pcap --out tcpsyn.cfg -n 2
    trafgen --conf tcpsyn.cfg --out ${NODE1_NIC} --num 1000 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen --conf failed"
    rm -f tcpsyn.pcap tcpsyn.cfg
    trafgen -e | trafgen -i - -o lo --cpp -n 1 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -o failed"
    trafgen -e | trafgen -i - -d lo --cpp -n 1 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -d failed"
    trafgen -e | trafgen -i - --out lo --cpp -n 1 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --out failed"
    trafgen -e | trafgen -i - --dev lo --cpp -n 1 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --dev failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
