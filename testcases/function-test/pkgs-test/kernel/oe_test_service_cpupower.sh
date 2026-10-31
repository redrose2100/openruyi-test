#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test cpupower.service restart
# #############################################
# shellcheck disable=SC1091,SC2119
source "../common/common_lib.sh"
# 发行版信息兼容层：openRuyi 等衍生发行版没有 /etc/openEuler-release。
source "${OET_PATH}/libs/locallibs/os_release_lib.sh"

# 原逻辑是 `grep -v SP1 /etc/openEuler-release`，即当发行版不是 SP1 时才改策略。
# 换成基于 /etc/os-release 的判断，兼容没有 openEuler-release 的衍生发行版。
function is_not_sp1_release() {
    local ver
    ver=$(OS_RELEASE_VERSION_ID)
    case "${ver}" in
        *SP1*) return 1 ;;
        *) return 0 ;;
    esac
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL kernel-tools
    if is_not_sp1_release; then
        sed -i 's/ondemand/powersave/g' /etc/sysconfig/cpupower
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if ! hostnamectl | grep Virtualization; then
        test_execution cpupower.service
        test_reload cpupower.service
    else
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if is_not_sp1_release; then
        sed -i 's/powersave/ondemand/g' /etc/sysconfig/cpupower
    fi
    DNF_REMOVE
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
