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
# @Desc      :   Test gala-anteater restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pip install pingouin==0.5.3
    pip install numpy==1.26.4
    systemctl stop firewalld
    DNF_INSTALL "gala-anteater kafka"
    sed -i '3s/true/false/g' /etc/gala-anteater/module/slow_node_detection.job.json
    cp /opt/kafka/config/server.properties /opt/kafka/config/server.properties-bak
    cp /etc/gala-anteater/config/gala-anteater.yaml /etc/gala-anteater/config/gala-anteater.yaml-bak
    sed -i 's/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/'"${NODE1_IPV4}"':9092/g' /opt/kafka/config/server.properties
    cd /opt/kafka/bin/ || exit 0
    ./zookeeper-server-start.sh  -daemon /opt/kafka/config/zookeeper.properties >/dev/null 2>&1 &
    SLEEP_WAIT 300
    ./kafka-server-start.sh -daemon /opt/kafka/config/server.properties >/dev/null 2>&1 &
    SLEEP_WAIT 5
    sed -i '0,/server: "localhost"/{s/server: "localhost"/server: '"${NODE1_IPV4}"'/}' /etc/gala-anteater/config/gala-anteater.yaml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution gala-anteater.service
    test_reload gala-anteater.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pip uninstall pingouin==0.5.3 -y
    pip uninstall numpy==1.26.4 -y
    systemctl stop gala-anteater.service
    sed -i '3s/false/true/g' /etc/gala-anteater/module/slow_node_detection.job.json
    pgrep -f -a "kafka-server-start|zookeeper-server-start" | awk '{print $1}' | xargs kill -9
    systemctl start firewalld
    mv -f /opt/kafka/config/server.properties-bak /opt/kafka/config/server.properties
    mv -f /etc/gala-anteater/config/gala-anteater.yaml-bak /etc/gala-anteater/config/gala-anteater.yaml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
