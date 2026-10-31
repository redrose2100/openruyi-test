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
# @Desc      :   Test qemu-crypto-aes-sm3
# #############################################
source "${OET_PATH}/testcases/function-test/pkgs-test/qemu/common/common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    version=$(grep "^VERSION=" /etc/os-release | cut -d= -f2 | tr -d '"' | tr -cs '[:alnum:].-' '-' | sed 's/-$//')
    img_url="https://repo.openeuler.org/openEuler-${version}/virtual_machine_img/$(arch)/openEuler-${version}-$(arch).qcow2.xz"
    filename=$(basename "${img_url}")
    volume=${filename%.xz}
    enc_volume=${volume%.qcow2}_aes_sm3.qcow2
    DNF_INSTALL "curl xz socat expect libvirt qemu-img"
    systemctl start libvirtd
    SLEEP_WAIT 3
    # firewalld is only stopped for the duration of this run;
    # post_test restores the state recorded here.
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    systemctl stop firewalld
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    uuid=$(uuidgen)
    test_crypto_qcow2_aes_sm3 "${uuid}" "${enc_volume}"
    CHECK_RESULT $? 0 0 "qcow2 aes sm3 test failed"
    deletesecvm "${uuid}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cleanup "${enc_volume}" "${volume}"
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld || LOG_WARN "Failed to restart firewalld to its original state."
    fi
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
