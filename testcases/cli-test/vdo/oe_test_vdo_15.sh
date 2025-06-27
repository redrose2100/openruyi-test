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
# @Author    :   cuikeyu
# @Contact   :   cky2536184321@163.com
# @Date      :   2023/09/21
# @License   :   Mulan PSL v2
# @Desc      :   Test vdo
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "vdo"
    dd if=/dev/zero of=vdo_test_device bs=1M count=10240
    losetup /dev/loop0 vdo_test_device
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_15."

    vdoformat --help | grep "OPTIONS"
    CHECK_RESULT $? 0 0 "Check vdoformat --help failed"

    vdoformat /dev/loop0 --force | grep "Logical blocks"
    CHECK_RESULT $? 0 0 "Check vdoformat --force failed"

    vdoformat --logical-size=10G /dev/loop0 --force
    CHECK_RESULT $? 0 0 "Check vdoformat --logical-size failed"

    vdoformat /dev/loop0 --slab-bits=19 --force | grep "defaulted"
    CHECK_RESULT $? 0 0 "Check vdoformat --slab-bits failed"

    if vdoformat --help | grep "uds-checkpoint-frequency"; then
        vdoformat /dev/loop0 --uds-checkpoint-frequency=10 --force
        CHECK_RESULT $? 0 0 "Check vdoformat --uds-checkpoint-frequency failed"
    else
        LOG_INFO "vdoformat --uds-checkpoint-frequency option is not exist"
    fi

    vdoformat /dev/loop0 --uds-memory-size=0.5 --force | grep "Logical blocks"
    CHECK_RESULT $? 0 0 "Check vdoformat --uds-memory-size failed"

    vdoformat /dev/loop0 --verbose --force | grep "Formatting '/dev/loop0'"
    CHECK_RESULT $? 0 0 "Check vdoformat --verbose failed"

    vdoformat --version | grep "vdoformat version"
    CHECK_RESULT $? 0 0 "Check vdoformat --version -a failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    losetup -d /dev/loop0
    rm vdo_test_device -f
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
