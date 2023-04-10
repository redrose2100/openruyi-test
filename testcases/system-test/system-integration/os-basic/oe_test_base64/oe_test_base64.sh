#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Command test-base64
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "password" | base64|grep cGFzc3dvcmQK
    CHECK_RESULT $? 0 0 "encryption failure"
    echo "cGFzc3dvcmQK" | base64 -d|grep password
    CHECK_RESULT $? 0 0  "decryption failure"
    echo "cGFzc3dvcmQK" | base64 -i|grep Y0dGemMzZHZjbVFLCg==
    CHECK_RESULT $? 0 0  "failed to check parameter -i"
    base64 --version|grep Copyright     
    CHECK_RESULT $? 0 0  "check version fail"
    base64 --help|grep base64
    CHECK_RESULT $? 0 0  "check help fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

