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
    LOG_INFO "Start to run testcase:oe_test_vdo_modify_02."

    ### --vdoBioRotationInterval <ioCount> ###
    vdo modify -n my_vdo_volume --vdoBioRotationInterval 128
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoBioRotationInterval No Pass"

    ### --vdoBioThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoBioThreads 4
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoBioThreads No Pass"

    ### --vdoCpuThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoCpuThreads 4
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoCpuThreads No Pass"

    ### --vdoHashZoneThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoHashZoneThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoHashZoneThreads No Pass"

    ### --vdoLogicalThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoLogicalThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoLogicalThreads No Pass"

    ### --vdoPhysicalThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoPhysicalThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoPhysicalThreads No Pass"

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