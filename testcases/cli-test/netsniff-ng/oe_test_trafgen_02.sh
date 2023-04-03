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
    # test --cpp
    trafgen --cpp --dev lo --conf ./data/synflood.trafgen -n 3 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --cpp failed"
    # test -p
    trafgen -p --dev lo --conf ./data/synflood.trafgen -n 3 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -p failed"
    # test --define
    trafgen --cpp --define ETH_P_IP=0x0800 --dev lo --conf ./data/synflood_nodefine.trafgen -n 3 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --define failed"
    # test -D
    trafgen --cpp -D ETH_P_IP=0x0800 --dev lo --conf ./data/synflood_nodefine.trafgen -n 3 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -D failed"
    # test -J
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -J -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -J failed"
    # test --jumbo-support
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' --jumbo-support -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --jumbo-support failed"
    # test -R
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -R  > msg.tmp 2>&1
    grep "It's probably not a mac80211 device!" msg.tmp
    CHECK_RESULT $? 0 0 "Check trafgen -R failed"
    rm -f msg.tmp
    #test --rfraw
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' --rfraw  > msg.tmp 2>&1
    grep "It's probably not a mac80211 device!" msg.tmp
    CHECK_RESULT $? 0 0 "Check trafgen --rfraw failed"
    rm -f msg.tmp
    # test --smoke-test
    netsniff-ng --in ${NODE1_NIC} --out tcpsyn.pcap -n 2
    netsniff-ng --in tcpsyn.pcap --out tcpsyn.cfg -n 2
    trafgen --dev ${NODE1_NIC} --conf tcpsyn.cfg --smoke-test 127.0.0.1 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen --smoke-test failed"
    rm -f tcpsyn.cfg tcpsyn.pcap
    # test -s
    netsniff-ng --in ${NODE1_NIC} --out tcpsyn.pcap -n 2
    netsniff-ng --in tcpsyn.pcap --out tcpsyn.cfg -n 2
    trafgen --dev ${NODE1_NIC} --conf tcpsyn.cfg -s 127.0.0.1 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen -s failed"
    rm -f tcpsyn.cfg tcpsyn.pcap
    # test -n
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -n failed"
    # test --num
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' --num 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -n failed"
    # test --rand
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' --rand -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen --rand failed"
    # test -r
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -r -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen -r failed"
    # test -P
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -P 2 -n 5 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -P failed"
    # test --cpus
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' --cpus 2 -n 5 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --cpus failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
