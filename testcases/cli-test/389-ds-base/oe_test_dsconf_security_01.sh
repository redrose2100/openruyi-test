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
# @Author    :   hu xintao
# @Contact   :   806908118@qq.com
# @Date      :   2023/09/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf security" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost security -h | grep "usage: dsconf.* instance security"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security -h No Pass"
    dsconf localhost security set -h | grep "usage: dsconf.* instance security set"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set -h No Pass"
    dsconf localhost security set --security on
    dsconf localhost security get | grep "nsslapd-security: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --security No Pass"
    dsconf localhost security set --listen-host ""
    dsconf localhost security get | grep "nsslapd-securelistenhost: "
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --listen-host No Pass"
    dsconf localhost security set --secure-port 636
    dsconf localhost security get | grep "nsslapd-secureport: 636"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --secure-port No Pass"
    dsconf localhost security set --tls-client-auth allowed
    dsconf localhost security get | grep "nssslclientauth: allowed"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-client-auth No Pass"
    dsconf localhost security set --tls-client-renegotiation allowed
    dsconf localhost security get | grep "nstlsallowclientrenegotiation: allowed"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-client-renegotiation No Pass"
    dsconf localhost security set --require-secure-authentication off
    dsconf localhost security get | grep "nsslapd-require-secure-binds: off"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --require-secure-authentication No Pass"
    dsconf localhost security set --check-hostname on
    dsconf localhost security get | grep "nsslapd-ssl-check-hostname: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --check-hostname No Pass"
    dsconf localhost security set --verify-cert-chain-on-startup warn
    dsconf localhost security get | grep "nsslapd-validate-cert: warn"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --verify-cert-chain-on-startup No Pass"
    dsconf localhost security set --session-timeout 0
    dsconf localhost security get | grep "nssslsessiontimeout: 0"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --session-timeout No Pass"
    dsconf localhost security set --tls-protocol-min TLS1.2
    dsconf localhost security get | grep "sslversionmin: TLS1.2"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-protocol-min No Pass"
    dsconf localhost security set --tls-protocol-max TLS1.3
    dsconf localhost security get | grep "sslversionmax: TLS1.3"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-protocol-max No Pass"
    dsconf localhost security set --allow-insecure-ciphers ""
    dsconf localhost security get | grep "allowweakcipher: "
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --allow-insecure-ciphers No Pass"
    dsconf localhost security set --allow-weak-dh-param ""
    dsconf localhost security get | grep "allowweakdhparam: "
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --allow-weak-dh-param No Pass"
    dsconf localhost security set --cipher-pref ""
    dsconf localhost security get | grep "nsssl3ciphers: "
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --cipher-pref No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dsctl localhost remove --do-it
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"