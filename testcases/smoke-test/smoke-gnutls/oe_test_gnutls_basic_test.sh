#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024/10/29
# @Desc      :   gnutls tls connect test 
# ##################################
# shellcheck disable=SC1091,SC2002,SC2035
source comlib.sh

function pre_test() {
    DNF_INSTALL gnutls-utils
    DNF_INSTALL gnutls-utils 2
    P_SSH_CMD --cmd "systemctl stop firewalld"
    check_time
    create_ca_cert
    create_server_cert
    create_client_cert
}

function run_test() {
    LOG_INFO "Start to run test."

    P_SSH_CMD --cmd "gnutls-serv --http --x509cafile ca-cert.pem --x509certfile server-cert.pem --x509keyfile server-key.pem --port 50051" &
    wait_server_start 50051
    gnutls-cli "$ETS_REMOTE_IP" --port 50051 --x509cafile ca-cert.pem --x509certfile client-cert.pem --x509keyfile client-key.pem --verify-hostname localhost > client.log
    check_connect client.log
    CHECK_RESULT $? 0 0 "connect failed first."
    gnutls-cli "$ETS_REMOTE_IP" --port 50051 --x509cafile ca-cert.pem --verify-hostname localhost > client.log
    check_connect client.log
    CHECK_RESULT $? 0 0 "connect failed second."

    P_SSH_CMD --cmd "gnutls-serv --http --x509certfile server-cert.pem --x509keyfile server-key.pem --port 50052" &
    wait_server_start 50052
    gnutls-cli "$ETS_REMOTE_IP" --port 50052 --x509cafile ca-cert.pem --x509certfile client-cert.pem --x509keyfile client-key.pem --verify-hostname localhost > client.log
    check_connect client.log
    CHECK_RESULT $? 0 0 "connect failed third."
    gnutls-cli "$ETS_REMOTE_IP" --port 50052 --x509cafile ca-cert.pem --verify-hostname localhost > client.log
    check_connect client.log
    CHECK_RESULT $? 0 0 "connect failed fourth."

    LOG_INFO "End of the test."
}

function post_test() {
    P_SSH_CMD --cmd "pkill -9 gnutls-serv"
    P_SSH_CMD --cmd "systemctl start firewalld"
    rm -rf *.log *.pem *.tmpl
    P_SSH_CMD --cmd "rm -rf *.pem *.tmpl"
    DNF_REMOVE
    DNF_REMOVE 2
}

main "$@"