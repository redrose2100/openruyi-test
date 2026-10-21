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
    touch /var/log/vdo_modify.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_modify_01."

    vdo modify --help | grep "usage: vdo modify"
    CHECK_RESULT $? 0 0 "Check vdo modify --help failed"

    vdo modify -a --blockMapCacheSize 256M | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify -a failed"

    vdo modify -n my_vdo_volume --blockMapCacheSize 256M | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify -n failed"

    vdo modify -n my_vdo_volume --blockMapCacheSize 256M -f /etc/vdoconf.yml | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify -f failed"

    vdo modify -n my_vdo_volume --blockMapCacheSize 256M --logfile /var/log/vdo_modify.log | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --logfile <pathname> failed"

    vdo modify --verbose -n my_vdo_volume --blockMapCacheSize 256M | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --verbose failed"

    vdo modify -n my_vdo_volume --blockMapCacheSize 256M | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --blockMapCacheSize failed"

    vdo modify -n my_vdo_volume --blockMapPeriod 200 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --blockMapPeriod failed"

    vdo modify -n my_vdo_volume --maxDiscardSize 8K | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --maxDiscardSize failed"

    vdo modify -n my_vdo_volume --vdoAckThreads 2 | grep "Changes"
    CHECK_RESULT $? 0 0 "Check vdo modify --vdoAckThreads failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_modify.log
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
