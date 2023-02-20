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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    systemctl stop firewalld
    cp /opt/kafka/config/server.properties /opt/kafka/config/server.properties-bak
    cp /etc/gala-anteater/config/gala-anteater.yaml /etc/gala-anteater/config/gala-anteater.yaml-bak
    DNF_INSTALL "gala-anteater kafka"
    sed -i 's/listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/${NODE1_IPV4}:9092/g' /opt/kafka/config/server.properties
    ./opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties >/dev/null 2>&1 &
    SLEEP_WAIT 60
    ./opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties >/dev/null 2>&1 &
    sed -i '0,/server: "localhost"/{s/server: "localhost"/server: "${NODE1_IPV4}"/}' /etc/gala-anteater/config/gala-anteater.yaml
    LOG_INFO "End environmental preparation."
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution gala-anteater.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop gala-anteater.service
    systemctl start firewalld
    mv -f /opt/kafka/config/server.properties-bak /opt/kafka/config/server.properties
    mv -f /etc/gala-anteater/config/gala-anteater.yaml-bak /etc/gala-anteater/config/gala-anteater.yaml
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
