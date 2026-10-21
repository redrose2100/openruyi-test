#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2024/5/13
# @License   :   Mulan PSL v2
# @Desc      :   Test atune-rest.service restart
# #############################################
#shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "atune-rest atune"
    disk_name=$(lsblk | grep disk | awk 'NR==1{print $1}')
    sed -i "s\disk = sda\disk = ${disk_name}\g" /etc/atuned/atuned.cnf
    sed -i "s\network = enp189s0f0\network = ${NODE1_NIC}\g" /etc/atuned/atuned.cnf
    sed -i "s\rest_tls = true\rest_tls = false\g" /etc/atuned/atuned.cnf
    sed -i "s\engine_tls = true\engine_tls = false\g" /etc/atuned/atuned.cnf
    systemctl start atuned.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution atune-rest.service
    test_reload atune-rest.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop atuned.service
    sed -i "s\disk = ${disk_name}\disk = sda\g" /etc/atuned/atuned.cnf
    sed -i "s\network = ${NODE1_NIC}\network = enp189s0f0\g" /etc/atuned/atuned.cnf
    sed -i "s\rest_tls = false\rest_tls = true\g" /etc/atuned/atuned.cnf
    sed -i "s\engine_tls = false\engine_tls = true\g" /etc/atuned/atuned.cnf
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
