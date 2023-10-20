#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/10/12
# @Desc      :   openssl sm test
# ##################################
# shellcheck disable=SC2035
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    echo "abcdefghi" > data
}

function run_test() {
    LOG_INFO "Start to run test."
    openssl ecparam -name SM2 -out SM2.pem
    CHECK_RESULT $? 0 0 "generate sm2 parameters failed"
    openssl req -config ./openssl.cnf -nodes -subj '/C=AA/ST=BB/O=CC/OU=DD/CN=root ca' -keyout CA.key -newkey sm2:SM2.pem -new -out CA.csr
    CHECK_RESULT $? 0 0 "generate sm2 request failed"
    openssl x509 -sm3 -req -days 30 -in CA.csr -extfile ./openssl.cnf -extensions v3_ca -signkey CA.key -out CA.crt
    CHECK_RESULT $? 0 0 "generate sm3 certificate failed"

    openssl req -config ./openssl.cnf -nodes -subj '/C=AA/ST=BB/O=CC/OU=DD/CN=server sign' -keyout SS.key -newkey sm2:SM2.pem -new -out SS.csr
    CHECK_RESULT $? 0 0 "generate sm2 request failed"
    openssl x509 -sm3 -req -days 30 -in SS.csr -CA CA.crt -CAkey CA.key -extfile ./openssl.cnf -extensions v3_req -out SS.crt -CAcreateserial
    CHECK_RESULT $? 0 0 "generate level 2 sm3 certificate failed"
    openssl req -config ./openssl.cnf -nodes -subj '/C=AA/ST=BB/O=CC/OU=DD/CN=server enc' -keyout SE.key -newkey sm2:SM2.pem -new -out SE.csr
    CHECK_RESULT $? 0 0 "generate sm2 request failed"
    openssl x509 -sm3 -req -days 30 -in SE.csr -CA CA.crt -CAkey CA.key -extfile ./openssl.cnf -extensions v3enc_req -out SE.crt -CAcreateserial
    CHECK_RESULT $? 0 0 "generate level 2 sm3 certificate failed"

    openssl x509 -text -in CA.crt
    CHECK_RESULT $? 0 0 "check certificate info failed"

    openssl ecparam -genkey -name SM2 -out priv.key
    CHECK_RESULT $? 0 0 "generate sm2 private key failed"
    openssl ec -in priv.key -pubout -out pub.key
    CHECK_RESULT $? 0 0 "extract public key failed"
    openssl dgst -sm3 -sign priv.key -out data.sig data
    CHECK_RESULT $? 0 0 "sm3 sign failed"
    openssl dgst -sm3 -verify pub.key -signature data.sig data
    CHECK_RESULT $? 0 0 "sm3 verify failed"
    openssl dgst -sm3 data
    CHECK_RESULT $? 0 0 "generate sm3 digest value failed"
    openssl enc -sm4 -in data -K 123456789ABCDEF0123456789ABCDEF0 -iv 123456789ABCDEF0123456789ABCDEF0 -out data.enc
    CHECK_RESULT $? 0 0 "sm4 enc failed"
    openssl enc -d -sm4 -in data.enc -K 123456789ABCDEF0123456789ABCDEF0 -iv 123456789ABCDEF0123456789ABCDEF0 -out data.raw
    CHECK_RESULT $? 0 0 "sm4 dec failed"
    diff data data.raw
    CHECK_RESULT $? 0 0 "sm4 verify failed"
    LOG_INFO "End of the test."
}

function post_test() {
    rm -rf *.crt *.csr *.key *.srl *.pem data*
}

main "$@"

