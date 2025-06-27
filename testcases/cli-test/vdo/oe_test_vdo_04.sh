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
    touch /var/log/vdo_disableCompression.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_04."

    vdo disableCompression --help | grep "usage: vdo disableCompression"
    CHECK_RESULT $? 0 0 "Check vdo disableCompression --help failed"

    vdo disableCompression -a | grep "Disabling compression"
    CHECK_RESULT $? 0 0 "Check vdo disableCompression -a failed"

    vdo disableCompression -n my_vdo_volume | grep "Disabling compression"
    CHECK_RESULT $? 0 0 "Check vdo disableCompression -n failed"

    vdo disableCompression --verbose -n my_vdo_volume | grep "Disabling compression"
    CHECK_RESULT $? 0 0 "Check vdo disableCompression --verbose failed"

    vdo disableCompression -n my_vdo_volume -f /etc/vdoconf.yml | grep "Disabling compression"
    CHECK_RESULT $? 0 0 "Check vdo disableCompression -f failed"

    vdo disableCompression -n my_vdo_volume --logfile /var/log/vdo_disableCompression.log | grep "Disabling compression"
    CHECK_RESULT $? 0 0 "Check vdo disableCompression --logfile failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_disableCompression.log
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
