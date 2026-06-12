#!/usr/bin/env bash

# Copyright (c) 2026. Huawei Technologies Co., Ltd. ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026/06/12
# @License   :   Mulan PSL v2
# @Desc      :   test cxl_pci.ko.xz module
# ###############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mod_name="cxl_pci"
    DNF_INSTALL "kmod"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # 检查模块文件是否存在
    test -f "/lib/modules/$(uname -r)/kernel/drivers/cxl/${mod_name}.ko.xz"
    CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"

    # 查看模块信息
    modinfo "${mod_name}"
    CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"

    # 加载模块
    modprobe "${mod_name}"
    CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"

    # 检查是否加载成功
    lsmod | grep -q "${mod_name}"
    CHECK_RESULT $? 0 0 "${mod_name} is not loaded"

    # 卸载模块
    modprobe -r "${mod_name}"
    CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"

    # 检查是否卸载成功
    lsmod | grep -q "${mod_name}"
    CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    modprobe -r "${mod_name}" 2>/dev/null
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

