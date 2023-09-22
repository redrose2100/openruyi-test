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
    LOG_INFO "Start to run testcase:oe_test_vdo_09."

    vdo list --help | grep "usage: vdo list"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"

    vdo list -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"

    vdo list --verbose 
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"

    vdo list  -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    
    touch /var/log/vdo_list.log
    vdo list  --logfile /var/log/vdo_list.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_list.log

    vdo printConfigFile --help | grep "usage: vdo printConfigFile"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"

    vdo printConfigFile --verbose 
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"

    vdo printConfigFile  -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    
    touch /var/log/vdo_printConfigFile.log
    vdo printConfigFile  --logfile /var/log/vdo_printConfigFile.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_printConfigFile.log

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