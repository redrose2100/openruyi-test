#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   duanxuemin
# @Contact   :   1820463064@qq.com
# @Date      :   2023/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test gala-gopher.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    systemctl stop firewalld
    if rpm -ql cyrus-sasl; then
        flag=true
        DNF_REMOVE 1 "cyrus-sasl"
    fi
    DNF_INSTALL "kafka gala-gopher"
    cp /opt/kafka/config/server.properties /opt/kafka/config/server.properties-bak
    cp /etc/gala-gopher/gala-gopher.conf /etc/gala-gopher/gala-gopher.conf-bak
    sed -i 's/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/'"${NODE1_IPV4}"':9092/g' /opt/kafka/config/server.properties
    cd /opt/kafka/bin/ || exit 0
    ./zookeeper-server-start.sh  -daemon /opt/kafka/config/zookeeper.properties >/dev/null 2>&1 &
    SLEEP_WAIT 300
    ./kafka-server-start.sh -daemon /opt/kafka/config/server.properties >/dev/null 2>&1 &
    SLEEP_WAIT 5
    sed -i 's/"localhost:9092"/"'"${NODE1_IPV4}"':9092"/g' /etc/gala-gopher/gala-gopher.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution gala-gopher.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop gala-gopher.service
    pgrep -f -a "kafka-server-start|zookeeper-server-start" | awk '{print $1}' | xargs kill -9
    systemctl start firewalld
    mv -f /opt/kafka/config/server.properties-bak /opt/kafka/config/server.properties
    mv -f /etc/gala-gopher/gala-gopher.conf-bak /etc/gala-gopher/gala-gopher.conf
    DNF_REMOVE "$@"
    if [ "${flag}" = "true" ]; then
        DNF_INSTALL "cyrus-sasl"
    fi
    LOG_INFO "End to restore the test environment."
}

main "$@"
