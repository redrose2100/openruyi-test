#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linmengmeng
#@Contact       :   linmengmeng@huawei.com
#@Date          :   2024-11-15
#@License       :   Mulan PSL v2
#@Desc          :   A-tune
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "test start"
    DNF_INSTALL "atune atune-engine"
}

function run_test() {
    # check service status
    systemctl status atuned | grep -w 'inactive'
    CHECK_RESULT $? 0 0 'atuned service status is inactive'

    systemctl status atune-engine | grep -w 'inactive'
    CHECK_RESULT $? 0 0 'atune-engine service status is inactive'

    # reset  config to start
    cp -arf /etc/atuned/atuned.cnf /etc/atuned/atuned.cnf_bak
    eth_name=$(ifconfig -a | head -1 | awk -F ':' '{print $1}')
    sed -i 's/^rest_tls[[:space:]]*=[[:space:]]*true/rest_tls = false/' /etc/atuned/atuned.cnf
    sed -i 's/^rest_tls[[:space:]]*=[[:space:]]*true/engine_tls= false/' /etc/atuned/atuned.cnf
    sed -i 's/^rest_tls[[:space:]]*=[[:space:]]*true/engine_tls= false/' /etc/atuned/engine.cnf
    sed -i "s/^network[[:space:]]*=[[:space:]]*enp189s0f0/network = $eth_name/" /etc/atuned/atuned.cnf

    # start service
    systemctl start atuned
    systemctl start atune-engine

    # check service status
    systemctl status atuned | grep -w 'active'
    CHECK_RESULT $? 0 0 'atuned service status is active'
    systemctl status atune-engine | grep -w 'active'
    CHECK_RESULT $? 0 0 'atune-engine service status is active'

    # stop service
    systemctl stop atuned
    systemctl stop atune-engine

    # check service status
    systemctl status atuned | grep -w 'inactive'
    CHECK_RESULT $? 0 0 'atuned service status is inactive'
    systemctl status atune-engine | grep -w 'inactive'
    CHECK_RESULT $? 0 0 'atune-engine service status is inactive'
}

function post_test() {
    mv /etc/atuned/atuned.cnf_bak /etc/atuned/atuned.cnf
    DNF_REMOVE "$@"
    LOG_INFO "test end"
}

main "$@"
