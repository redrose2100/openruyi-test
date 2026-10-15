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
# @Desc      :   Test virtcca-compute.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "virtcca-manager virtcca-compute hostname python3-zope-schema"
    localhostname=$(hostname)
    hostname manager
    mkdir -p /etc/virtcca_deploy/cert/
    openssl genrsa -out /etc/virtcca_deploy/cert/ca.key 4096
    openssl req -x509 -new -nodes -key /etc/virtcca_deploy/cert/ca.key -sha256 -days 3650  -out /etc/virtcca_deploy/cert/ca.crt -subj "/C=CN/ST=Shanghai/L=Shanghai/O=TestCA/OU=Dev/CN=VirtccaRootCA"
    bash gen_cert.sh --ca-cert /etc/virtcca_deploy/cert/ca.crt --ca-key /etc/virtcca_deploy/cert/ca.key --cn manager --dns manager --ip "${NODE1_IPV4}" --out-dir /etc/virtcca_deploy/cert/
    bash gen_cert.sh --ca-cert /etc/virtcca_deploy/cert/ca.crt --ca-key /etc/virtcca_deploy/cert/ca.key --cn compute --dns compute --ip "${NODE1_IPV4}" --out-dir /etc/virtcca_deploy/cert/
    chown virtcca /etc/virtcca_deploy/cert/*
    cp -rf /etc/virtcca_deploy/virtcca_deploy.conf /etc/virtcca_deploy/virtcca_deploy.conf.bak
    echo "[DEFAULT]
manager = manager
cvm_image_path = /var/lib/virtcca_deploy/qcow2

[MANAGER]
ca_cert = /etc/virtcca_deploy/cert/ca.crt
server_cert = /etc/virtcca_deploy/cert/manager.crt
server_key = /etc/virtcca_deploy/cert/manager.key
client_cert = /etc/virtcca_deploy/cert/manager.crt
client_key = /etc/virtcca_deploy/cert/manager.key

[COMPUTE]
ca_cert = /etc/virtcca_deploy/cert/ca.crt
server_cert = /etc/virtcca_deploy/cert/compute.crt
server_key = /etc/virtcca_deploy/cert/compute.key
client_cert = /etc/virtcca_deploy/cert/compute.crt
client_key = /etc/virtcca_deploy/cert/compute.key
iso_repo = /dev/sr0
">/etc/virtcca_deploy/virtcca_deploy.conf
    systemctl start virtcca-manager.service
    SLEEP_WAIT 5
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution virtcca-compute.service
    test_reload virtcca-compute.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop virtcca-manager.service
    systemctl stop virtcca-compute.service
    rm -rf /etc/virtcca_deploy/cert/*
    mv -f /etc/virtcca_deploy/virtcca_deploy.conf.bak /etc/virtcca_deploy/virtcca_deploy.conf
    DNF_REMOVE
    hostname "${localhostname}"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
