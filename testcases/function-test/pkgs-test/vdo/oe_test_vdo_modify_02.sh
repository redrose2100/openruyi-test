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
    LOG_INFO "Start to run testcase:oe_test_vdo_modify_02."

    vdo modify -n my_vdo_volume --vdoBioRotationInterval 128 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoBioRotationInterval failed"

    vdo modify -n my_vdo_volume --vdoBioThreads 4 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoBioThreads failed"

    vdo modify -n my_vdo_volume --vdoCpuThreads 4 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoCpuThreads failed"

    vdo modify -n my_vdo_volume --vdoHashZoneThreads 2 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoHashZoneThreads failed"

    vdo modify -n my_vdo_volume --vdoLogicalThreads 2 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoLogicalThreads failed"

    vdo modify -n my_vdo_volume --vdoPhysicalThreads 2 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoPhysicalThreads failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
