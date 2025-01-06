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
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2023/05/04
# @License   :   Mulan PSL v2
# @Desc      :   Test argus.service restart
# #############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL argus
    if yum list installed | grep cyrus-sasl; then 
        dnf remove -y  cyrus-sasl
        flag=1      
    fi
    network_card=$(ip -o link show | awk -F': ' '$2 !~ /lo/ {print $2; exit}')
    echo "ARGUS_INTERFACE=$network_card" >> /etc/argus.conf
    sed -i "s\argus.pid\argus.$network_card.0.pid\g" /usr/lib/systemd/system/argus.service
    systemctl daemon-reload
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution argus.service
    test_reload argus.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i "/#ARGUS_INTERFACE=$network_card/d" /etc/argus.conf
    sed -i "s\argus.$network_card.0.pid\argus.pid\g" /usr/lib/systemd/system/argus.service
    systemctl daemon-reload
    systemctl stop argus.service
    if [ "${flag}" == "1" ]; then
        dnf install -y cyrus-sasl
    fi
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

