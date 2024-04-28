#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author: zhangpanting
# @Contact : 1768492250@qq.com
# @Date: 2024/4/23
# @License : Mulan PSL v2
# @Desc: Test gala-spider restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    systemctl stop firewalld
    if rpm -ql cyrus-sasl; then
        flag=true
        DNF_REMOVE 1 "cyrus-sasl"
    fi
    DNF_INSTALL "kafka gala-spider"
    cp -f /opt/kafka/config/server.properties /opt/kafka/config/server.properties-bak
    cp -f /etc/gala-spider/gala-spider.yaml /etc/gala-spider/gala-spider.yaml-bak
    sed -i 's/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/'"${NODE1_IPV4}"':9092/g' /opt/kafka/config/server.properties
    cd /opt/kafka/bin/ || exit 1
    ./zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties >/dev/null 2>&1 &
    SLEEP_WAIT 300
    ./kafka-server-start.sh -daemon /opt/kafka/config/server.properties >/dev/null 2>&1 &
    sed -i 's/server: "localhost:9092"/server: "'"${NODE1_IPV4}"':9092"/g' /etc/gala-spider/gala-spider.yaml
    sed -i 's/localhost:8529/'"${NODE1_IPV4}"':8529/g' /etc/gala-spider/gala-spider.yaml
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart gala-spider.service
    CHECK_RESULT $? 0 0 "gala-spider.service restart failed"
    SLEEP_WAIT 5
    systemctl status gala-spider.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "gala-spider.service restart failed"
    systemctl stop gala-spider.service
    CHECK_RESULT $? 0 0 "gala-spider.service stop failed"
    SLEEP_WAIT 5
    systemctl status gala-spider.service | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "gala-spider.service stop failed"
    systemctl start gala-spider.service
    CHECK_RESULT $? 0 0 "gala-spider.service start failed"
    SLEEP_WAIT 5
    systemctl status gala-spider.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "gala-spider.service start failed"
    test_enabled gala-spider.service
    test_reload gala-spider.service
    journalctl --since "${log_time}" -u gala-spider.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|Max retries exceed"
    test_reload gala-spider.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop gala-spider.service
    systemctl start firewalld
    pgrep -f -a "kafka-server-start|zookeeper-server-start" | awk '{print $1}' | xargs kill -9
    mv -f /opt/kafka/config/server.properties-bak /opt/kafka/config/server.properties
    mv -f /etc/gala-spider/gala-spider.yaml-bak /etc/gala-spider/gala-spider.yaml
    DNF_REMOVE "$@"
    if [ "${flag}" = "true" ]; then
        DNF_INSTALL "cyrus-sasl"
    fi
    LOG_INFO "End to restore the test environment."
}

main "@"
