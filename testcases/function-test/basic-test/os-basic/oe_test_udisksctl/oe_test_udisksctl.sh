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
# @Author    :   ut001707
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-05-20
# @License   :   Mulan PSL v2
# @Desc      :   Command test-cal
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # Install udisks2 directly on the local node: DNF_INSTALL goes through
    # SSH_CMD on the execution node, which can fail silently on openRuyi.
    # udisks2 is provided by the openRuyi repo (verified on 12057).
    dnf -y install udisks2 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to install udisks2"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}



function run_test() {
    LOG_INFO "Start to run test."
    udisksctl info  2>&1 |grep -i 'Show information about an object'
    CHECK_RESULT $? 0 0 "check udisksctl inifo failed"
    fist_disk=$(lsblk -d -o NAME | grep -E '^(nvme|s)[a-z]+$' | head -n 1)
    udisksctl status | grep -i "$fist_disk"
    CHECK_RESULT $? 0 0  "check udisks_status failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
