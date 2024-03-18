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

source ../common/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gala-gopher kafka"
    systemctl stop firewalld
    cp /opt/kafka/config/server.properties /opt/kafka/config/server.properties-bak
    cp /etc/gala-gopher/gala-gopher.conf /etc/gala-gopher/gala-gopher.conf-bak
    echo "listeners=PLAINTEXT://${NODE1_IPV4}:9092" >> /opt/kafka/config/server.properties
    /opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties >/dev/null 2>&1 &
    SLEEP_WAIT 60
    /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties >/dev/null 2>&1 &
    sed -i 's/kafka_broker = .*/kafka_broker = "'"${NODE1_IPV4}"':9092";/' /etc/gala-gopher/gala-gopher.conf     
    SLEEP_WAIT 30
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution gala-gopher.service
    systemctl restart gala-gopher.service
    systemctl status gala-gopher.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop gala-gopher.service
    mv -f /opt/kafka/config/server.properties-bak /opt/kafka/config/server.properties
    mv -f /etc/gala-gopher/gala-gopher.conf-bak /etc/gala-gopher/gala-gopher.conf
    pgrep -f zookeeper | xargs kill -9
    rm -rf /tmp/kafka-logs
    systemctl start firewalld
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
