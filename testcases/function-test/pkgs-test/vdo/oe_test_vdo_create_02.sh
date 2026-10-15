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
# @Date      :   2023/09/20
# @License   :   Mulan PSL v2
# @Desc      :   Test vdo
# #############################################
# shellcheck disable=SC1091
source "common/common_vdo.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_create_02."
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --deduplication enabled | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --deduplication failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --emulate512 enabled | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --emulate512 failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --force | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --force failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --indexMem 0.25 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --indexMem failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --maxDiscardSize 1G | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --maxDiscardSize failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --sparseIndex disabled | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --sparseIndex failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoAckThreads 1 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoAckThreads failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoBioRotationInterval 64 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoBioRotationInterval failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoBioThreads 4 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoBioThreads failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoCpuThreads 2 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoCpuThreads failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
