#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2025/04/30
# @License   :   Mulan PSL v2
# @Desc      :   内核增加华为hinic3网卡驱动
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    LOG_INFO "Nothing to do."
}

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    test -f "/lib/modules/$kernel_name/kernel/drivers/net/ethernet/huawei/hinic3/hinic3.ko.xz"
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo hinic3 |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe hinic3
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep hinic3
    CHECK_RESULT $? 0 0 "Module not loaded"
    rmmod hinic3
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep hinic3
    CHECK_RESULT $? 1 0 "Module loaded"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
