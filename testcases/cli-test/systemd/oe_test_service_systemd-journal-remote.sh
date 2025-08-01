#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/08/01
# @License   :   Mulan PSL v2
# @Desc      :   Test systemd-journal-remote.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL systemd-journal-remote
    if ! rpm -ql systemd-journal-remote | grep systemd-journal-remote.service;then
        exit 255
    fi
    mkdir -p /etc/ssl/ca /etc/ssl/certs /etc/ssl/private
    chmod 700 /etc/ssl/private
    chmod 755 /etc/ssl/ca /etc/ssl/certs
    openssl genrsa -out /etc/ssl/ca/ca.key 4096
    chmod 600 /etc/ssl/ca/ca.key
    tee /etc/ssl/ca/ca.cnf <<'EOF'
[ req ]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn

[ dn ]
C = CN
ST = Beijing
L = Beijing
O = My Organization
OU = CA Department
CN = My Internal CA

[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:TRUE
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
EOF
    
    openssl req -x509 -new -nodes -key /etc/ssl/ca/ca.key \
    -days 3650 -out /etc/ssl/ca/ca.crt \
    -config /etc/ssl/ca/ca.cnf -extensions v3_ca
    cp /etc/ssl/ca/ca.crt /etc/ssl/ca/trusted.pem
    openssl genrsa -out /etc/ssl/private/journal-remote.key 2048
    chmod 600 /etc/ssl/private/journal-remote.key
    tee /etc/ssl/certs/journal-remote.cnf <<'EOF'
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[ dn ]
C = CN
ST = Beijing
L = Beijing
O = My Organization
OU = Journal Remote
CN = journal-remote.example.com

[ v3_req ]
subjectAltName = DNS:journal-remote.example.com
extendedKeyUsage = serverAuth
keyUsage = digitalSignature, keyEncipherment
EOF
    openssl req -new -key /etc/ssl/private/journal-remote.key \
    -out /etc/ssl/certs/journal-remote.csr \
    -config /etc/ssl/certs/journal-remote.cnf
    openssl x509 -req -in /etc/ssl/certs/journal-remote.csr \
    -CA /etc/ssl/ca/ca.crt -CAkey /etc/ssl/ca/ca.key -CAcreateserial \
    -out /etc/ssl/certs/journal-remote.pem \
    -days 365 -sha256 \
    -extfile /etc/ssl/certs/journal-remote.cnf -extensions v3_req
    chmod 755 /etc/ssl/private/ -R
    echo -e "ServerKeyFile=/etc/ssl/private/journal-remote.key\nServerCertificateFile=/etc/ssl/certs/journal-remote.pem\nTrustedCertificateFile=/etc/ssl/ca/trusted.pem" >> /etc/systemd/journal-remote.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution systemd-journal-remote.service
    test_reload systemd-journal-remote.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environmental preparation."
    rm -rf /etc/ssl/ca/ca* /etc/ssl/ca/trusted.pem /etc/ssl/certs/journal-remote* /etc/ssl/private/journal-remote*
    DNF_REMOVE "$@"
    LOG_INFO "End of environmental preparation!"
}

main "$@"
