#!/usr/bin/env bash

# Copyright (c) 2026. Huawei Technologies Co., Ltd. ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026/04/21
# @License   :   Mulan PSL v2
# @Desc      :   kernel regmap-spi module test
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # 检查regmap-spi是否为内核内置模块
    if grep regmap-spi /lib/modules/"$(uname -r)"/modules.builtin; then
        LOG_WARN "regmap-spi is builtin, skipping module load/unload steps"
        exit 255
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    # 进入regmap模块所在目录
    cd /usr/lib/modules/"${kernel_name}"/kernel/drivers/base/regmap || exit
    # 检查regmap-spi.ko.xz文件是否存在
    test -f regmap-spi.ko.xz 
    CHECK_RESULT $? 0 0 "regmap-spi.ko.xz file does not exist"
    # 加载regmap-spi模块
    modprobe regmap-spi
    CHECK_RESULT $? 0 0 "regmap-spi module load failed"
    # 检查模块版本信息
    modinfo regmap-spi | grep version
    CHECK_RESULT $? 0 0 "regmap-spi module version info check failed"
    # 验证模块是否成功加载
    lsmod | grep regmap_spi
    CHECK_RESULT $? 0 0 "regmap-spi module loaded check failed"
    # 卸载regmap-spi模块
    rmmod regmap_spi
    CHECK_RESULT $? 0 0 "regmap-spi module unload failed"
    # 验证模块是否成功卸载
    lsmod | grep regmap_spi
    CHECK_RESULT $? 1 0 "regmap-spi module not unloaded completely"

}

function post_test() {
    LOG_INFO "Start environment cleanup."
    # 确保模块被卸载
    rmmod regmap-spi &>/dev/null
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

