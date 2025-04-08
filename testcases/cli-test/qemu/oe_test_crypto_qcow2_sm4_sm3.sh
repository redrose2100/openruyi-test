#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   cheliequan
# @Contact   :   cheliequan@inspur.com
# @Date      :   2024/10/28
# @License   :   Mulan PSL v2
# @Desc      :   Test qemu-crypto-sm4-sm3
# #############################################
OET_PATH=$(readlink -f "../../../")
source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/qemu/common/common.sh"
filename=$(basename "${img_url}")
volume=${filename%.xz}
enc_volume=${volume%.qcow2}_sm4_sm3.qcow2

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "curl xz socat expect libvirt"
    systemctl start libvirt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    uuid=$(uuidgen)
    test_crypto_qcow2_sm4_sm3 "${uuid}" "${enc_volume}"
    CHECK_RESULT $? 0 0 "qcow2 sm4 sm3 test failed" 
    deletesecvm "${uuid}"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    cleanup "${enc_volume}" "${volume}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
