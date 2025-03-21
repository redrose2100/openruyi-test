#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199611@126.com
# @Date      :   2023/10/12
# @Desc      :   ssh sm test
# ##################################
# shellcheck disable=SC1091
source lib.sh

function pre_test() {
    send_pub
    modify_ssh_client_conf
    modify_ssh_server_conf
    P_SSH_CMD --cmd "systemctl restart sshd"
    systemctl restart sshd 
}

function run_test() {
    LOG_INFO "Start to run test."
    expect << EOF
    spawn ssh -o PreferredAuthentications=publickey -o HostKeyAlgorithms=sm2 -o PubkeyAcceptedKeyTypes=sm2 -o Ciphers=sm4-ctr -o MACs=hmac-sm3 -o KexAlgorithms=sm2-sm3 -i ~/.ssh/id_sm2 ${NODE2_IPV4} -p ${NODE2_SSH_PORT} "ip a | grep lo"
    expect "Are you sure you want to continue connecting*"
    send "yes\n"
    catch wait result;
    exit [lindex \$result 3]
EOF
    CHECK_RESULT $? 0 0 "ssh sm3 failed" 
    LOG_INFO "End of the test."
}

function post_test() {
    cleanup 
}

main "$@"

