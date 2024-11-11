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
    dsconf localhost security rsa -h | grep "usage: dsconf.* instance security rsa"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa -h No Pass"
    dsconf localhost security rsa set -h | grep "usage: dsconf.* instance security rsa set"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set -h No Pass"
    dsconf localhost security rsa set --tls-allow-rsa-certificates on
    dsconf localhost security rsa get | grep "nssslactivation: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set --tls-allow-rsa-certificates No Pass"
    dsconf localhost security rsa set --nss-cert-name Server-Cert
    dsconf localhost security rsa get | grep "nssslpersonalityssl: Server-Cert"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set --nss-cert-name No Pass"
    dsconf localhost security rsa set --nss-token "internal (software)"
    dsconf localhost security rsa get | grep "nsssltoken: internal"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set --nss-token No Pass"
    dsconf localhost security rsa get -h | grep "usage: dsconf.* instance security rsa get"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa get -h No Pass"
    dsconf localhost security rsa get | grep "nssslactivation: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa get No Pass"
    dsconf localhost security rsa enable -h | grep "usage: dsconf.* instance security rsa enable"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa enable -h No Pass"
    dsconf localhost security rsa disable -h | grep "usage: dsconf.* instance security rsa disable"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa disable -h No Pass"
    dsconf localhost security rsa disable
    dsconf localhost security rsa get | grep "nssslactivation: off"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa disable No Pass"
    dsconf localhost security rsa enable
    dsconf localhost security rsa get | grep "nssslactivation: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa enable No Pass"
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