#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-04-12
# @License   :   Mulan PSL v2
# @Desc      :   内核-驱动-网讯网卡驱动
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    kopath1=$(find /lib/modules/$(uname -r)/kernel/drivers/net/ -name ngbe)
    kopath2=$(find /lib/modules/$(uname -r)/kernel/drivers/net/ -name txgbe)   
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cd $kopath1
    modinfo ngbe.ko | grep "name:" | grep "ngbe"
    CHECK_RESULT $? 0 0 "Module ngbe not found" 
    insmod ngbe.ko
    CHECK_RESULT $? 0 0 "insmod ngbe.ko failed"
    lsmod | grep ngbe
    CHECK_RESULT $? 0 0 "lsmod failed"
    rmmod ngbe
    CHECK_RESULT $? 0 0 "rmmod ngbe failed"
    lsmod | grep ngbe
    CHECK_RESULT $? 1 0 "ngbe info exist"
    dmesg |grep ngbe
    CHECK_RESULT $? 0 0 "Failed to detect information"

    cd $kopath2
    modinfo txgbe.ko | grep "name:" | grep "txgbe"
    CHECK_RESULT $? 0 0 "Module txgbe not found" 
    insmod txgbe.ko
    CHECK_RESULT $? 0 0 "insmod txgbe.ko failed"
    lsmod | grep txgbe
    CHECK_RESULT $? 0 0 "lsmod failed"
    rmmod txgbe
    CHECK_RESULT $? 0 0 "rmmod txgbe failed"
    lsmod | grep txgbe
    CHECK_RESULT $? 1 0 "txgbe info exist"
    dmesg |grep ngbe
    CHECK_RESULT $? 0 0 "Failed to detect information"
    LOG_INFO "Finish test!"
}

main $@
