#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test python3-libvirt basic functionality
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-libvirt libvirt"
    systemctl start libvirtd
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test python3-libvirt module import
    python3 -c "import libvirt"
    CHECK_RESULT $? 0 0 "python3-libvirt module import failed"
    # Test libvirt version information
    python3 -c "import libvirt; v=libvirt.getVersion(); print(f'{v//1000000}.{(v%1000000)//1000}.{v%1000}')" | grep "$(rpm -qa python3-libvirt | awk -F '-' '{print $3}')"
    CHECK_RESULT $? 0 0 "libvirt version did not match package version"
    # Test libvirt constant retrieval
    python3 -c "import libvirt; print(libvirt.VIR_DOMAIN_RUNNING)" | grep -q "^[0-9]*$"
    CHECK_RESULT $? 0 0 "libvirt constant VIR_DOMAIN_RUNNING get failed"
    # Test connection to local QEMU hypervisor
    python3 -c "import libvirt; conn = libvirt.open('qemu:///system'); conn.close()"
    CHECK_RESULT $? 0 0 "libvirt connection to qemu:///system failed"
    # Test connection to local QEMU session
    python3 -c "import libvirt; conn = libvirt.open('qemu:///session'); conn.close()"
    CHECK_RESULT $? 0 0 "libvirt connection to qemu:///session failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"