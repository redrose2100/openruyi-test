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
    dsconf localhost security ciphers -h | grep "usage: dsconf.*instance.*security ciphers"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers -h No Pass"
    dsconf localhost security ciphers enable -h | grep "usage: dsconf.*instance.*security ciphers enable"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers enable -h No Pass"
    dsconf localhost security ciphers disable -h | grep "usage: dsconf.*instance.*security ciphers disable"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers disable -h No Pass"
    dsconf localhost security ciphers get -h | grep "usage: dsconf.*instance.*security ciphers get"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers get -h No Pass"
    dsconf localhost security ciphers set -h | grep "usage: dsconf.*instance.*security ciphers set"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers set -h No Pass"
    dsconf localhost security ciphers list -h | grep "usage: dsconf.*instance.*security ciphers list"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list -h No Pass"
    dsconf localhost security ciphers set test1 | grep "Remember to restart the server to apply the new cipher set"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers set No Pass"
    dsconf localhost security ciphers get | grep "test1"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers get No Pass"
    dsconf localhost security ciphers enable test1 | grep "Cipher test1 is not supported."
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers enable No Pass"
    dsconf localhost security ciphers disable test1 | grep "Cipher test1 is not supported."
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers disable No Pass"
    dsconf localhost security ciphers list | grep "test1"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list No Pass"
    dsconf localhost security ciphers list --enable | grep "TLS_AES_128_GCM_SHA256"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list --enable No Pass"
    dsconf localhost security ciphers list --supported | grep "TLS_AES_128_GCM_SHA256"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list --supported No Pass"
    dsconf localhost security ciphers list --disabled | grep "TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list --disable No Pass"
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