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
# shellcheck disable=SC2119,2010
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar wget"
    #兼容rv环境，设置虚拟机默认路由
    if [ "$(arch)" = "riscv64" ]; then
        IP_CIDR=$(ip addr show "${NODE1_NIC}" | awk '/inet / {print $2; exit}')
        GATEWAY_IP=$(echo "$IP_CIDR" | cut -d'/' -f1 | sed 's/\.[0-9]*$/\.1/')
        sudo ip route del default 2>/dev/null || true
        sudo ip route add default via "$GATEWAY_IP" dev "${NODE1_NIC}"
    fi
    #模拟tcp请求
    nohup wget -O /dev/null http://speedtest.tele2.net/10GB.zip > wget.log 2>&1 &    
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    netsniff-ng --in "${NODE1_NIC}" --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --interval failed"
    pids=$(pgrep -f "netsniff-ng --in") && kill -9 "$pids"
    rm -f ./data/*.pcap
    netsniff-ng --in "${NODE1_NIC}" --out ./data/ -s -m -F 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -F failed"
    pids=$(pgrep -f "netsniff-ng --in") && kill -9 "$pids"
    rm -f ./data/*.pcap
    netsniff-ng --in lo -R --out tmp.cfg -s > tmp.txt  2>&1
    grep "It's probably not a mac80211" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng -R failed"
    rm -f tmp.txt
    netsniff-ng --in lo --rfraw --out tmp.cfg -s > tmp.txt  2>&1
    grep "It's probably not a mac80211" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng --rfraw failed"
    rm -f tmp.txt
    netsniff-ng -s --in "${NODE1_NIC}" --out dump.cfg -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -n failed"
    rm -f dump.cfg
    netsniff-ng -s --in "${NODE1_NIC}" --out dump.cfg --num 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --num failed"
    rm -f dump.cfg
    netsniff-ng --in "${NODE1_NIC}" --prefix netsniff-dump --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "netsniff-dump"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --prefix failed"
    pids=$(pgrep -f "netsniff-ng --in") && kill -9 "$pids"
    rm -f ./data/netsniff-dump*
    netsniff-ng --in "${NODE1_NIC}" -P netsniff-dump --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "netsniff-dump"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -P failed"
    pids=$(pgrep -f "netsniff-ng --in") && kill -9 "$pids"
    rm -f ./data/netsniff-dump*
    netsniff-ng --in "${NODE1_NIC}" --overwrite 2 --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    test -f ./data/dump-0000000000.pcap
    CHECK_RESULT $? 0 0 "Check netsniff-ng --overwrite failed"
    pids=$(pgrep -f "netsniff-ng --in") && kill -9 "$pids"
    rm -f ./data/*.pcap
    netsniff-ng --in "${NODE1_NIC}" -O 2 --out ./data/ -s -m --interval 100MiB &
    SLEEP_WAIT 5
    ls ./data | grep "dump-0000000000.pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -O failed"
    pids=$(pgrep -f "netsniff-ng --in") && kill -9 "$pids"
    rm -f ./data/*.pcap
    netsniff-ng --in "${NODE1_NIC}" --out dump.cfg -s -T 0xa1e2cb12 -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -T failed"
    rm -f dump.cfg
    netsniff-ng --in "${NODE1_NIC}" --out dump.cfg -s --magic 0xa1e2cb12 -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --magic failed"
    rm -f dump.cfg
    netsniff-ng --in "${NODE1_NIC}" -w -n 2 | grep 'Linux "cooked"'
    CHECK_RESULT $? 0 0 "Check netsniff-ng -w failed"
    netsniff-ng --in "${NODE1_NIC}" --cooked -n 2 | grep 'Linux "cooked"'
    CHECK_RESULT $? 0 0 "Check netsniff-ng --cooked failed"
    rm -f dump.cfg
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 "$(pgrep wget)"
    if [ "$(arch)" = "riscv64" ]; then
        sudo ip route del default 2>/dev/null || true
    fi
    rm -rf ./data/ ./common/*.sh wget.log
    LOG_INFO "End to restore the test environment."
}
main "$@"
