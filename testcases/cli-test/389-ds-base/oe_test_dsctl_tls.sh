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
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsctl" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf -D "cn=Directory Manager" localhost backend create --suffix="dc=example,dc=net" --be-name="example"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsctl tls -h | grep "usage: dsctl.*instance.*tls"
    CHECK_RESULT $? 0 0 "L$LINENO: tls -h No Pass"
    dsctl localhost tls list-ca | grep "Self-Signed-CA"
    CHECK_RESULT $? 0 0 "L$LINENO: tls list-ca No Pass"
    dsctl localhost tls list-client-ca | grep "Self-Signed-CA"
    CHECK_RESULT $? 0 0 "L$LINENO: tls list-client-ca No Pass"
    dsctl localhost tls show-server-cert | grep "Certificate"
    CHECK_RESULT $? 0 0 "L$LINENO: tls show-server-cert No Pass"
    dsctl localhost tls generate-server-cert-csr -h | grep "usage: dsctl.*instance.*tls generate-server-cert-csr"
    CHECK_RESULT $? 0 0 "L$LINENO: tls generate-server-cert-csr -h No Pass"
    dsctl localhost tls generate-server-cert-csr | grep "/etc/dirsrv/slapd-localhost/Server-Cert.csr"
    CHECK_RESULT $? 0 0 "L$LINENO: tls generate-server-cert-csr No Pass"
    dsctl localhost tls generate-server-cert-csr --subject "CN=server.example.com,O=example_organization" | grep -E "/etc/dirsrv/slapd-localhost/Server-Cert.csr"
    CHECK_RESULT $? 0 0 "L$LINENO: tls generate-server-cert-csr --subject No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
