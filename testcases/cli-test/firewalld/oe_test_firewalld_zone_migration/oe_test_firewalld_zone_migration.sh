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
#@Desc          :   Test firewalld zone migration
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    sshpass_status=1
    P_SSH_CMD --node 2 --cmd "which sshpass" || {
	    P_SSH_CMD --node 2 --cmd "yum install sshpass -y"
            sshpass_status=0
    }

    LOG_INFO "Start firewalld"

    # Origin status of firewalld
    origin="start"
    systemctl is-active firewalld || {
	    systemctl start firewalld
    	    origin="stop"
    }
    systemctl is-active firewalld || systemctl restart firewalld

    tstz="zonetest"
    tstp="65535/tcp"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    CMD_String="sshpass -p ${NODE1_PASSWORD} ssh -o 'StrictHostKeyChecking no' ${NODE1_USER}@${NODE1_IPV4} 'cat /etc/os-release'"

    LOG_INFO "CMD on node2: $CMD_String"
    LOG_INFO "expect success"
    P_SSH_CMD --node 2 --cmd "${CMD_String}"
    CHECK_RESULT "$?" 0 0 "ssh NODE1_IPV4 fail"

    LOG_INFO "Create test zone: $tstz"
    firewall-cmd --get-zones | grep "$tstz" || firewall-cmd --new-zone="$tstz" --permanent
    firewall-cmd --reload

    firewall-cmd --get-zones |grep "$tstz"
    CHECK_RESULT "$?" 0 0 "zone not exists: $tstz"

    firewall-cmd --zone="$tstz" --add-source="${NODE2_IPV4}"
    firewall-cmd --zone="$tstz" --add-port="$tstp"
    
    LOG_INFO "Current zone info:"
    firewall-cmd --list-all --zone="$tstz"

    firewall-cmd --list-all --zone="$tstz" | grep "sources" | grep "${NODE2_IPV4}"
    CHECK_RESULT "$?" 0 0 "add source fail for $tstz"

    firewall-cmd --list-all --zone="$tstz" | grep "ports" | grep "$tstp"
    CHECK_RESULT "$?" 0 0 "add ports fail for $tstz"

    LOG_INFO "CMD on node2: $CMD_String"
    LOG_INFO "expect fail"
    P_SSH_CMD --node 2 --cmd "${CMD_String}"
    CHECK_RESULT "$?" 0 1 "ssh NODE1_IPV4 succeeds unexpectedly. Firewalld zone migration failed"

    firewall-cmd --delete-zone="$tstz" --permanent
    firewall-cmd --reload

    LOG_INFO "CMD on node2: $CMD_String"
    LOG_INFO "expect success"
    P_SSH_CMD --node 2 --cmd "${CMD_String}"
    CHECK_RESULT "$?" 0 0 "ssh NODE1_IPV4 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    [[ "$sshpass_status" == "0" ]] && \
	    P_SSH_CMD --node 2 --cmd "yum remove sshpass -y"

    LOG_INFO "Remove test zone: $tstz"
    firewall-cmd --get-zones | grep "$tstz"  && \
            firewall-cmd --delete-zone="$tstz" --permanent
    firewall-cmd --reload

    LOG_INFO "Restore firewalld status to: $origin"
    systemctl $origin firewalld
    LOG_INFO "End to restore the test environment."
}

main "$@"
