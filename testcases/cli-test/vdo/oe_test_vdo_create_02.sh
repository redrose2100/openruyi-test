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
# @Desc      :   Test perl-Module-Build
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "vdo"
    dd if=/dev/zero of=vdo_test_device bs=1M count=10240
    losetup /dev/loop0 vdo_test_device
    vdo create -n my_vdo_volume --device /dev/loop0
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_create_02."

    vdo remove -n my_vdo_volume 

    vdo create -n my_vdo_volume --device /dev/loop0 --deduplication enabled
    CHECK_RESULT $? 0 0 "L$LINENO: --deduplication No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --emulate512 enabled
    CHECK_RESULT $? 0 0 "L$LINENO: --emulate512 No Pass"
    vdo remove -n my_vdo_volume
    
    vdo create -n my_vdo_volume --device /dev/loop0 --force
    CHECK_RESULT $? 0 0 "L$LINENO: --force No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --indexMem 0.25
    CHECK_RESULT $? 0 0 "L$LINENO: --indexMem No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --maxDiscardSize 1G
    CHECK_RESULT $? 0 0 "L$LINENO: --maxDiscardSize No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --sparseIndex disabled
    CHECK_RESULT $? 0 0 "L$LINENO: --sparseIndex No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoAckThreads 1
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoAckThreads No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0  --vdoBioRotationInterval 64
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoBioRotationInterval No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoBioThreads 4
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoBioThreads No Pass"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --vdoCpuThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoCpuThreads No Pass"
    vdo remove -n my_vdo_volume

    losetup -d /dev/loop0
    rm vdo_test_device -f


    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"