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
    vdo create -n my_vdo_volume --device /dev/loop0
    touch /var/log/vdo_disableDeduplication.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_05."

    vdo disableDeduplication --help | grep "usage: vdo disableDeduplication"
    CHECK_RESULT $? 0 0 "Check vdo disableDeduplication --help failed"

    vdo disableDeduplication -a | grep "Disabling deduplication"
    CHECK_RESULT $? 0 0 "Check vdo disableDeduplication -a failed"

    vdo disableDeduplication -n my_vdo_volume | grep "Disabling deduplication"
    CHECK_RESULT $? 0 0 "Check vdo disableDeduplication -n failed"

    vdo disableDeduplication --verbose -n my_vdo_volume | grep "Disabling deduplication"
    CHECK_RESULT $? 0 0 "Check vdo disableDeduplication --verbose failed"

    vdo disableDeduplication -n my_vdo_volume -f /etc/vdoconf.yml | grep "Disabling deduplication"
    CHECK_RESULT $? 0 0 "Check vdo disableDeduplication -f failed"
 
    vdo disableDeduplication -n my_vdo_volume --logfile /var/log/vdo_disableDeduplication.log | grep "Disabling deduplication"
    CHECK_RESULT $? 0 0 "Check vdo disableDeduplication --logfile failed"
    
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_disableDeduplication.log
    vdo remove -n my_vdo_volume
    losetup -d /dev/loop0
    rm vdo_test_device -f
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"