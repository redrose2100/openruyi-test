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
    LOG_INFO "Start to run testcase:oe_test_vdo_08."

    vdo growLogical --help | grep "usage: vdo growLogical"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"

    vdo growLogical -n my_vdo_volume --vdoLogicalSize 6278748K
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"

    vdo growLogical --verbose -n my_vdo_volume --vdoLogicalSize 6278752K
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"

    vdo growLogical -n my_vdo_volume -f /etc/vdoconf.yml --vdoLogicalSize 6278756K
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    
    touch /var/log/vdo_growLogical.log 
    vdo growLogical -n my_vdo_volume --logfile /var/log/vdo_growLogical.log --vdoLogicalSize 6278760K
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_growLogical.log


    vdo remove -n my_vdo_volume --force
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