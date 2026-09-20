#!/usr/bin/env bash
# Copyright (c) 2026, Huawei Technologies Co., Ltd. ALL rights reserved.
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
# @Date      :   2026/06/11
# @License   :   Mulan PSL v2
# @Desc      :   test kmem.ko.xz module
# ###############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mod_name="kmem"
    DNF_INSTALL "kmod"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # 修正为实际路径 drivers/dax/
    test -f "/lib/modules/$(uname -r)/kernel/drivers/dax/${mod_name}.ko.xz"
    if [ $? = 0 ]; then
        CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
    else
        exit 255
        LOG_INFO "Module kmem not found, skipping test"
    fi

    # 查看模块信息
    modinfo "${mod_name}"
    CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"

    # 加载模块（已加载也不会报错）
    modprobe "${mod_name}"
    CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"

    # 检查模块存在（常驻模块，只需验证已加载）
    lsmod | grep -q "${mod_name}"
    CHECK_RESULT $? 0 0 "${mod_name} is not loaded"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

