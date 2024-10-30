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
#@Author        :   wangtingting 
#@Contact       :   wangting199611@126.com 
#@Date          :   2024/10/29
#@License       :   Mulan PSL v2
#@Desc          :   gnutls connect test public functions
####################################
# shellcheck disable=SC2129
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function check_time() {
    DNF_INSTALL ntpdate
    DNF_INSTALL ntpdate 2
    ntpdate -u szxntp01-in.huawei.com
    P_SSH_CMD --cmd "ntpdate -u szxntp01-in.huawei.com"
}

function wait_server_start() {
    local port=${1}
    for ((i = 0; i < 20; i++)); do
        P_SSH_CMD --cmd "netstat -lnpt | grep -w $port" && return 0
        sleep 0.5
    done
    return 1
}

function check_connect() {
    local file=${1}
    for ((i = 0; i < 20; i++)); do
	cat "$file" | grep -v "error" | grep "Handshake was completed" && return 0
        sleep 0.5
    done
    return 1
}

function create_ca_cert() {
    echo "cn = GnuTLS test CA" > ca.tmpl
    echo "expiration_days = 365" >> ca.tmpl
    echo "ca" >> ca.tmpl
    echo "signing_key" >> ca.tmpl
    echo "cert_signing_key" >> ca.tmpl
    echo "crl_signing_key" >> ca.tmpl
    SFTP put --localdir ./ --localfile ca.tmpl --remotedir /root --node 2

    P_SSH_CMD --cmd "certtool --generate-privkey --outfile ca-key.pem"
    P_SSH_CMD --cmd "certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem"
    SFTP get --node 2 --remotedir "/root" --remotefile "ca-cert.pem" --localdir ./
    SFTP get --node 2 --remotedir "/root" --remotefile "ca-key.pem" --localdir ./
}

function create_server_cert() {
    echo "cn = test.gnutls.org" > server.tmpl
    echo "expiration_days = 365" >> server.tmpl
    echo "tls_www_server" >> server.tmpl
    echo "encryption_key" >> server.tmpl
    echo "signing_key" >> server.tmpl
    echo "dns_name = localhost" >> server.tmpl
    echo "ip_address = ${NODE2_IPV4}" >> server.tmpl
    SFTP put --localdir ./ --localfile server.tmpl --remotedir /root --node 2

    P_SSH_CMD --cmd "certtool --generate-privkey --outfile server-key.pem"
    P_SSH_CMD --cmd "certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem \
    --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem"
}

function create_client_cert() {
    echo "cn = test.gnutls.org" > client.tmpl
    echo "expiration_days = 365" >> client.tmpl
    echo "tls_www_client" >> client.tmpl
    echo "encryption_key" >> client.tmpl
    echo "signing_key" >> client.tmpl
    echo "dns_name = localhost" >> client.tmpl

    certtool --generate-privkey --outfile client-key.pem
    certtool --generate-certificate --load-privkey client-key.pem --load-ca-certificate ca-cert.pem \
        --load-ca-privkey ca-key.pem --template client.tmpl --outfile client-cert.pem
}
