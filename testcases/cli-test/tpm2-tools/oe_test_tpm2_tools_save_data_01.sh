#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lanyanling
# @Contact   :   lanyanling@uniontech.com
# @Date      :   2024-3-15
# @License   :   Mulan PSL v2
# @Desc      :   verify tpm2_clear,tpm2_nvreadpublic,tpm2_changeauth,tpm2_nvdefine,tpm2_nvwrite command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tpm2-tools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > key-file << EOF
this is key.
EOF
    ls -l /dev/tpm0
    CHECK_RESULT $? 0 0 "TPM device is not detected" 1
    tpm2_clear
    CHECK_RESULT $? 0 0 "Clean tpm's all data failed"
    tpm2_changeauth -c o uos_123
    CHECK_RESULT $? 0 0 "Set password failed"
    tpm2_nvdefine  -C o  -s 1024  -a "ownerread|policywrite|ownerwrite" 1 -P uos_123
    CHECK_RESULT $? 0 0 "Define nvram failed"
    tpm2_nvwrite  -C o 1  -i key-file -P uos_123
    CHECK_RESULT $? 0 0 "Write data failed"
    tpm2_nvread -C o 1 -s 32 -P uos_123
    CHECK_RESULT $? 0 0 "Read data failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf key-file
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
