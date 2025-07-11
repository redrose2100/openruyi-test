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
    LOG_INFO "Start to run testcase:oe_test_create_03."
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoHashZoneThreads 1 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoHashZoneThreads failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoLogicalSize 128M | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoLogicalSize failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoLogicalThreads 1 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoLogicalThreads failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoLogLevel info | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoLogLevel failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoPhysicalThreads 1 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoPhysicalThreads failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoSlabSize 128M | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --vdoSlabSize failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
