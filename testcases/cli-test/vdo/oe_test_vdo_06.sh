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
    touch /var/log/vdo_enableCompression.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_06."

    vdo enableCompression --help | grep "usage: vdo enableCompression"
    CHECK_RESULT $? 0 0 "Check vdo enableCompression --help failed"

    vdo enableCompression -a | grep "Enabling compression"
    CHECK_RESULT $? 0 0 "Check vdo enableCompression -a failed"

    vdo enableCompression -n my_vdo_volume | grep "Enabling compression"
    CHECK_RESULT $? 0 0 "Check vdo enableCompression -n failed"

    vdo enableCompression --verbose -n my_vdo_volume | grep "Enabling compression"
    CHECK_RESULT $? 0 0 "Check vdo enableCompression --verbose failed"

    vdo enableCompression -n my_vdo_volume -f /etc/vdoconf.yml | grep "Enabling compression"
    CHECK_RESULT $? 0 0 "Check vdo enableCompression -f failed"

    vdo enableCompression -n my_vdo_volume --logfile /var/log/vdo_enableCompression.log | grep "Enabling compression"
    CHECK_RESULT $? 0 0 "Check vdo enableCompression --logfile failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_enableCompression.log
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
