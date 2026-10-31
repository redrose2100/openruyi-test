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
# @Date      :   2026/07/01
# @License   :   Mulan PSL v2
# @Desc      :   Test virtcca-guest-agent.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "virtcca-guest-agent hostname python3-zope-schema"
    localhostname=$(hostname)
    hostname manager
    mkdir -p /etc/virtcca_deploy/cert/
    openssl genrsa -out /etc/virtcca_deploy/cert/ca.key 4096
    openssl req -x509 -new -nodes -key /etc/virtcca_deploy/cert/ca.key -sha256 -days 3650  -out /etc/virtcca_deploy/cert/ca.crt -subj "/C=CN/ST=Shanghai/L=Shanghai/O=TestCA/OU=Dev/CN=VirtccaRootCA"
    bash gen_cert.sh --ca-cert  /etc/virtcca_deploy/cert/ca.crt --ca-key  /etc/virtcca_deploy/cert/ca.key  --cn agent --dns agent-1 --out-dir  /etc/virtcca_deploy/cert/
    chown virtcca /etc/virtcca_deploy/cert/*
    cp -rf /etc/virtcca_deploy/virtcca_deploy.conf /etc/virtcca_deploy/virtcca_deploy.conf.bak
    echo "[DEFAULT]
manager = manager
cvm_image_path = /var/lib/virtcca_deploy/qcow2

[COMPUTE]
agent_cert = /etc/virtcca_deploy/cert/agent.crt
agent_key = /etc/virtcca_deploy/cert/agent.key
">/etc/virtcca_deploy/virtcca_deploy.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution virtcca-guest-agent.service
    test_reload virtcca-guest-agent.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop virtcca-guest-agent.service
    rm -rf /etc/virtcca_deploy/cert/*
    mv -f /etc/virtcca_deploy/virtcca_deploy.conf.bak /etc/virtcca_deploy/virtcca_deploy.conf
    DNF_REMOVE
    hostname "${localhostname}"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
