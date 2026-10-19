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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2024-01-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship auto start when reboot
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    SSH_CMD "dnf install -y pkgship wget net-tools diffutils tar
             bash /etc/pkgship/auto_install_pkgship_requires.sh redis
             bash /etc/pkgship/auto_install_pkgship_requires.sh elasticsearch
             systemctl start pkgship
             systemctl enable elasticsearch" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    SSH_CMD "chkconfig pkgship on" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Set pkgship auto start failed."
    REMOTE_REBOOT 2 30
    SLEEP_WAIT 60
    SSH_CMD "systemctl restart elasticsearch.service
    sleep 30
    systemctl restart redis.service
    systemctl status pkgship | grep 'active'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "pkgship start failed after reboot."
    SSH_CMD "chkconfig pkgship off" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    REMOTE_REBOOT 2 30
    SLEEP_WAIT 60
    SSH_CMD "systemctl restart elasticsearch.service
    sleep 30
    systemctl restart redis.service
    systemctl status pkgship | grep 'inactive'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "pkgship start unexpectly after reboot."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    SSH_CMD "systemctl disable elasticsearch
             systemctl stop elasticsearch
             systemctl stop redis
             rm -rf /etc/yum.repos.d/pkgship_elasticsearch.repo
             dnf clean packages
             dnf remove pkgship redis elasticsearch  wget net-tools diffutils -y" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to restore the test environment."
}

main "$@"
