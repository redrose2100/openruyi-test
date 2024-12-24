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
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-10-28
#@License       :   Mulan PSL v2
#@Desc          :   (pcp-system-tools) (pcp-uptime,pcp-verify)
#####################################
# shellcheck disable=SC1091,SC2154

source "common/common_pcp-system-tools.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    archive_data=$(pcp -h "$host_name" | grep 'primary logger:' | awk -F: '{print $NF}')
    OLD_PATH=$PATH
    export PATH=/usr/libexec/pcp/bin/:$PATH
    mkdir -p /etc/pcp/tls
    cat >/etc/pcp/tls/openssl.cnf <<_END_
[ server_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = server
[ client_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = client
_END_
    openssl genrsa -out /etc/pcp/tls/ca.key
    openssl req \
        -x509 -new -nodes -sha256 -days 3650 -key /etc/pcp/tls/ca.key \
        -subj '/O=PCP Authority/CN=Certificate Authority' \
        -out /etc/pcp/tls/ca.crt
    openssl genrsa -out /etc/pcp/tls/server.key 2048
    openssl req \
        -new -sha256 -subj '/O=PCP Authority/CN=PCP Collector' \
        -key /etc/pcp/tls/server.key |
        openssl x509 \
            -req -sha256 -days 365 \
            -CA /etc/pcp/tls/ca.crt \
            -CAkey /etc/pcp/tls/ca.key \
            -extfile /etc/pcp/tls/openssl.cnf -extensions server_cert \
            -out /etc/pcp/tls/server.crt
    openssl genrsa -out /etc/pcp/tls/client.key 2048
    openssl req \
        -new -sha256 -subj '/O=PCP Authority/CN=PCP Monitor' \
        -key /etc/pcp/tls/client.key |
        openssl x509 \
            -req -sha256 -days 365 \
            -CA /etc/pcp/tls/ca.crt \
            -CAkey /etc/pcp/tls/ca.key \
            -extfile /etc/pcp/tls/openssl.cnf -extensions client_cert \
            -out /etc/pcp/tls/client.crt
    chown -R pcp:pcp /etc/pcp/tls
    cat >/etc/pcp/tls.conf <<_END_
tls-ca-cert-file = /etc/pcp/tls/ca.crt
tls-key-file = /etc/pcp/tls/server.key
tls-cert-file = /etc/pcp/tls/server.crt
tls-client-key-file = /etc/pcp/tls/client.key
tls-client-cert-file = /etc/pcp/tls/client.crt
_END_
    systemctl restart pmcd
    systemctl restart pmlogger
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pcp-uptime --help 2>&1 | grep 'Usage'
    CHECK_RESULT $?
    pcp-uptime --version 2>&1 | grep "$pcp_version"
    CHECK_RESULT $?
    pcp-verify --help 2>&1 | grep 'Usage'
    CHECK_RESULT $?
    pcp-verify --version 2>&1 | grep "$pcp_version"
    CHECK_RESULT $?
    pcp-verify -h "$host_name"
    CHECK_RESULT $?
    pcp-verify -a "$archive_data"
    CHECK_RESULT $?
    pcp-verify -v | grep 'DEBUG'
    CHECK_RESULT $?
    pcp-verify -c
    CHECK_RESULT $?
    pcp-verify -s
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf /etc/pcp/tls
    PATH=${OLD_PATH}
    LOG_INFO "End to restore the test environment."
}

main "$@"
