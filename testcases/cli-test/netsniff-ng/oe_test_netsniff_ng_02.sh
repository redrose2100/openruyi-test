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
# @Desc      :   Test netsniff-ng
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
    netsniff-ng --in ${NODE1_NIC} --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --interval failed"
    kill -9 $(pgrep -f "netsniff-ng --in")
    rm -f ./data/*.pcap
    netsniff-ng --in ${NODE1_NIC} --out ./data/ -s -m -F 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -F failed"
    kill -9 $(pgrep -f "netsniff-ng --in")
    rm -f ./data/*.pcap
    netsniff-ng --in lo -R --out tmp.cfg -s > tmp.txt  2>&1
    grep "It's probably not a mac80211" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng -R failed"
    rm -f tmp.txt
    netsniff-ng --in lo --rfraw --out tmp.cfg -s > tmp.txt  2>&1
    grep "It's probably not a mac80211" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng --rfraw failed"
    rm -f tmp.txt
    netsniff-ng -s --in ${NODE1_NIC} --out dump.cfg -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -n failed"
    rm -f dump.cfg
    netsniff-ng -s --in ${NODE1_NIC} --out dump.cfg --num 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --num failed"
    rm -f dump.cfg
    netsniff-ng --in ${NODE1_NIC} --prefix netsniff-dump --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "netsniff-dump"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --prefix failed"
    kill -9 $(pgrep -f "netsniff-ng --in")
    rm -f ./data/netsniff-dump*
    netsniff-ng --in ${NODE1_NIC} -P netsniff-dump --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "netsniff-dump"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -P failed"
    kill -9 $(pgrep -f "netsniff-ng --in")
    rm -f ./data/netsniff-dump*
    netsniff-ng --in ${NODE1_NIC} --overwrite 2 --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    test -f ./data/dump-0000000000.pcap
    CHECK_RESULT $? 0 0 "Check netsniff-ng --overwrite failed"
    kill -9 $(pgrep -f "netsniff-ng --in")
    rm -f ./data/*.pcap
    netsniff-ng --in ${NODE1_NIC} -O 2 --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "dump-0000000000.pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -O failed"
    kill -9 $(pgrep -f "netsniff-ng --in")
    rm -f ./data/*.pcap
    netsniff-ng --in ${NODE1_NIC} --out dump.cfg -s -T 0xa1e2cb12 -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -T failed"
    rm -f dump.cfg
    netsniff-ng --in ${NODE1_NIC} --out dump.cfg -s --magic 0xa1e2cb12 -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --magic failed"
    rm -f dump.cfg
    netsniff-ng --in ${NODE1_NIC} -w -n 2 | grep 'Linux "cooked"'
    CHECK_RESULT $? 0 0 "Check netsniff-ng -w failed"
    netsniff-ng --in ${NODE1_NIC} --cooked -n 2 | grep 'Linux "cooked"'
    CHECK_RESULT $? 0 0 "Check netsniff-ng --cooked failed"
    rm -f dump.cfg
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
