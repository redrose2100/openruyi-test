#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2026/06/29
# @License   :   Mulan PSL v2
# @Desc      :   Test ums_agent.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/cli-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "umdk-ums-agent umdk-ums"
    mkdir -p /etc/ums_agent/certs/
    openssl req -newkey rsa:2048 -passout pass:"${NODE1_PASSWORD}" -keyout /etc/ums_agent/certs/ca_rsa_private.pem -x509 -days 365 -out /etc/ums_agent/certs/ca.crt -subj "/C=CN/ST=GD/L=SZ/O=COM/OU=NSP/CN=CA/emailAddress=xxxx@xxx.com"
    openssl req -newkey rsa:2048 -passout pass:"${NODE1_PASSWORD}" -keyout /etc/ums_agent/certs/server_rsa_private.pem -out /etc/ums_agent/certs/server.csr -subj "/C=CN/ST=GD/L=SZ/O=COM/OU=NSP/CN=SERVER/emailAddress=xxxx@xxx.com"
    openssl x509 -req -days 365 -in /etc/ums_agent/certs/server.csr -CA /etc/ums_agent/certs/ca.crt -CAkey /etc/ums_agent/certs/ca_rsa_private.pem -passin pass:"${NODE1_PASSWORD}" -CAcreateserial -out /etc/ums_agent/certs/server.crt
    openssl req -newkey rsa:2048 -passout pass:"${NODE1_PASSWORD}" -keyout /etc/ums_agent/certs/client_rsa_private.pem -out /etc/ums_agent/certs/client.csr -subj "/C=CN/ST=GD/L=SZ/O=COM/OU=NSP/CN=CLIENT/emailAddress=xxxx@xxx.com"
    openssl x509 -req -days 365 -in /etc/ums_agent/certs/client.csr -CA /etc/ums_agent/certs/ca.crt -CAkey /etc/ums_agent/certs/ca_rsa_private.pem -passin pass:"${NODE1_PASSWORD}" -CAcreateserial -out /etc/ums_agent/certs/client.crt
    sudo -u ums keyctl add user server_private_key_passphrase "${NODE1_PASSWORD}" @u
    sudo -u ums keyctl add user client_private_key_passphrase "${NODE1_PASSWORD}" @u
    sudo -u ums keyctl list @u
    chown ums:ums /etc/ums_agent/certs/ -R
    chmod 750 /etc/ums_agent/certs/
    chmod 644 /etc/ums_agent/certs/*.crt
    chmod 640 /etc/ums_agent/certs/*_private.pem /etc/ums_agent/certs/*.csr /etc/ums_agent/certs/*.srl
    modprobe ums
    cp -rf /etc/ums_agent/ums_agent.conf /etc/ums_agent/ums_agent.conf.bak
    echo "[logging]
log_level=info

[authenticate.client]
x509.truststore=/etc/ums_agent/certs/ca.crt
x509.certificate=/etc/ums_agent/certs/client.crt
x509.private_key=/etc/ums_agent/certs/client_rsa_private.pem
x509.prkey_pwd_desc=client_private_key_passphrase

[authenticate.server]
x509.truststore=/etc/ums_agent/certs/ca.crt
x509.certificate=/etc/ums_agent/certs/server.crt
x509.private_key=/etc/ums_agent/certs/server_rsa_private.pem
x509.prkey_pwd_desc=server_private_key_passphrase

[network]
listen_port=61080
listen_addr=0.0.0.0
max_conns=1024

[tls]
cipher_suite=TLS_AES_256_GCM_SHA384
">/etc/ums_agent/ums_agent.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution ums_agent.service
    test_reload ums_agent.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop ums_agent.service
    mv -f /etc/ums_agent/ums_agent.conf.bak /etc/ums_agent/ums_agent.conf
    modprobe -rf ums
    rm -rf /etc/ums_agent/certs
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
