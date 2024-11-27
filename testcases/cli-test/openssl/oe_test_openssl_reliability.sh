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
#@Date          :   2020-07-29
#@License       :   Mulan PSL v2
#@Desc          :   Pressure load : kill process,start service,acess request (Implements https based on httpd and OpenSSL)
#April's remind :   when running, You'd better not interrupt the program with Ctrl+C
#####################################
# shellcheck disable=SC1091,SC2154
source "common/common_openssl.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    DNF_INSTALL "httpd mod_ssl"
    createCA_and_Self_signed_certificate
    generate_PrivateKey_and_Certificate_Signing_Request
    CA_Signature_Authentication
    Modify_application_configuration
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart httpd && systemctl status httpd | grep "active"
    CHECK_RESULT $? 0 0 "Failed to restart httpd."
    curl --cacert /etc/pki/CA/cacert.pem https://www.openeuler.org/index.html -I 2>&1 | grep '200'
    CHECK_RESULT $? 0 0 "Failed to curl openeuler.org with cert."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_httpd_openssl
    systemctl stop httpd
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
