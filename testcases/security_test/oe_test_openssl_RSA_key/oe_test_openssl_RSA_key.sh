#! /usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2022-12-29
# @License   :   Mulan PSL v2
# @Desc      :   Test openssl_RSA key
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    mkdir key/ && cd key/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    openssl genrsa -out rsa_private.key 2048
    CHECK_RESULT $? 0 0 "Error, No build rsa_private.key"
    openssl rsa -in rsa_private.key -pubout -out rsa_public.key
    CHECK_RESULT $? 0 0 "Error, No build rsa_public.key"
    openssl genrsa -aes256 -passout pass:111111 -out rsa_aes_private.key 2048
    CHECK_RESULT $? 0 0 "Error, No build rsa_aes_private.key"
    openssl rsa -in rsa_aes_private.key -passin pass:111111 -out rsa_aes_private_nopasswd.key
    CHECK_RESULT $? 0 0 "Error, No build rsa_aes_private_nopasswd.key"
    openssl rsa -in rsa_aes_private_nopasswd.key -aes256 -passout pass:111111 -out rsa_aes_private_passwd.key
    CHECK_RESULT $? 0 0 "Error, Encryption rsa_aes_private_nopasswd.key failed"
    grep -e AES-256-CBC ./*key
    CHECK_RESULT $? 0 0 "key is not AES-256-CBC"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    cd .. && rm -rf key/
    LOG_INFO "End to clean the test environment."
}

main "$@"
