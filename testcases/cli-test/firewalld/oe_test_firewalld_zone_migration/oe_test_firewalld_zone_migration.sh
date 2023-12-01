#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2022-12-12
#@License       :   Mulan PSL v2
#@Desc          :   Firewalld zone migration is not supported
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    P_SSH_CMD --node 2 --cmd "which sshpass"
    if [[ "x$?" != "x0" ]];then
        P_SSH_CMD --node 2 --cmd "yum install sshpass -y"
        sshpass_status=0
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    CHECK_RESULT "$(firewall-cmd --state)" "running" 0 "firewalld.service not running"
    firewall-cmd --delete-zone=zonetest --permanent
    firewall-cmd --reload
    firewall-cmd --get-zones |grep zonetest
    CHECK_RESULT "$?" "0" 1 "default firewall zone check fail"
    CMD_String="sshpass -p ${NODE1_PASSWORD} ssh -o 'StrictHostKeyChecking no' ${NODE1_USER}@${NODE1_IPV4} 'cat /etc/os-release'"
    P_SSH_CMD --node 2 --cmd "${CMD_String}"
    CHECK_RESULT "$?" 0 0 "ssh NODE1_IPV4 fail"

    firewall-cmd --new-zone=zonetest --permanent
    firewall-cmd --reload
    firewall-cmd --get-zones |grep zonetest
    CHECK_RESULT "$?" 0 0 "add firewall zone check fail"

    firewall-cmd --zone=zonetest --add-source="${NODE2_IPV4}"
    firewall-cmd --zone=zonetest --add-port=65535/tcp
    CHECK_RESULT "$(firewall-cmd --list-all --zone=zonetest |grep sources |awk '{print $NF}')" "${NODE2_IPV4}" 0 "add source fail for zonetest"
    CHECK_RESULT "$(firewall-cmd --list-all --zone=zonetest |grep '^  ports' |awk '{print $NF}')" "65535/tcp" 0 "add ports fail for zonetest"
    P_SSH_CMD --node 2 --cmd "${CMD_String}"
    CHECK_RESULT "$?" 0 1 "ssh NODE1_IPV4 fail. Firewalld zone migration is not supported"

    firewall-cmd --delete-zone=zonetest --permanent
    firewall-cmd --reload
    P_SSH_CMD --node 2 --cmd "${CMD_String}"
    CHECK_RESULT "$?" 0 0 "ssh NODE1_IPV4 fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [[ "x$sshpass_status" == "x0" ]];then
        P_SSH_CMD --node 2 --cmd "yum remove sshpass -y"
    fi
    LOG_INFO "End to restore the test environment."
}

main "$@"
