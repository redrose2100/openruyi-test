#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-3-31
# @License   :   Mulan PSL v2
# @Desc      :   Command openssl sm2
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "start to run test."
    openssl ecparam -list_curves | grep SM2 | grep "SM2 curve over a 256 bit prime field"
    CHECK_RESULT $? 0 0 "openssl do not support sm2 encryption"
    openssl ecparam -genkey -name SM2 -out priv.key
    CHECK_RESULT $? 0 0 "generate private key failed"
    openssl ec -in priv.key -pubout -out pub.key
    CHECK_RESULT $? 0 0 "generate public key failed"
    stat -c %a  priv.key | grep 600
    CHECK_RESULT $? 0 0 "priv.key permission error"
    stat -c %a  pub.key | grep 644
    CHECK_RESULT $? 0 0 "pub.key permission error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f priv.key pub.key
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
