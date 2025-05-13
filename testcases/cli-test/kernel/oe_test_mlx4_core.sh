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
# @Date      :   2025/05/12
# @License   :   Mulan PSL v2
# @Desc      :   Test kernel-mellanox drive（mlx4_core）
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    LOG_INFO "Nothing to do."
}

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    test -f "/lib/modules/$kernel_name/kernel/drivers/net/ethernet/mellanox/mlx4/mlx4_core.ko.xz"
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo mlx4_core |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe mlx4_core
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep mlx4_core
    CHECK_RESULT $? 0 0 "Module not loaded"
    rmmod mlx4_core
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep mlx4_core
    CHECK_RESULT $? 1 0 "Module loaded"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
