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
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024/12/19
# @License   :   Mulan PSL v2
# @Desc      :   Test biosdecode
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [[ "$NODE1_FRAME" == "riscv64" || "$NODE1_FRAME" == "aarch64" ]]; then
        LOG_ERROR "The case exit because it is not suitable for riscv64 and aarch64"
	exit 255
    fi
    DNF_INSTALL dmidecode
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    local version
    version=$(biosdecode -V)
    CHECK_RESULT $? 0 0 "failed to get biosdecode version by -V"

    local usage
    usage=$(biosdecode -h)
    CHECK_RESULT $? 0 0 "failed to get usage by -h"

    biosdecode | grep "biosdecode $version"
    CHECK_RESULT $? 0 0 "biosdecode failed OR get a different version"

    biosdecode -d /dev/mem | grep "biosdecode $version"
    CHECK_RESULT $? 0 0 "biosdecode failed OR get a different version"

    echo "$usage" | grep "\-d"
    CHECK_RESULT $? 0 0 "lack of -d option in usage"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
