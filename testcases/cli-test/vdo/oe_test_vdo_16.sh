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
# shellcheck disable=SC1091
source "common/common_vdo.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_16."

    vdostats --help | grep -i "Usage: vdostats"
    CHECK_RESULT $? 0 0 "Check vdostats --help failed"

    vdostats --all my_vdo_volume | grep "my_vdo_volume : "
    CHECK_RESULT $? 0 0 "Check vdostats --all failed"

    vdostats --human-readable my_vdo_volume | grep "Available Use%"
    CHECK_RESULT $? 0 0 "Check vdostats --human-readable failed"

    vdostats --si my_vdo_volume | grep "Space saving%"
    CHECK_RESULT $? 0 0 "Check vdostats --si failed"

    vdostats --verbose my_vdo_volume | grep " release version"
    CHECK_RESULT $? 0 0 "Check vdostats --verbose failed"

    vdostats --version
    CHECK_RESULT $? 0 0 "Check vdostats --version failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
