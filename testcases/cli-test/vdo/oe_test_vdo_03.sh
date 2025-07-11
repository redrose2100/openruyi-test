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
    touch /var/log/vdo_deactivate.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_03."

    vdo deactivate --help | grep "usage: vdo deactivate"
    CHECK_RESULT $? 0 0 "Check vdo deactivate --help failed"

    vdo deactivate -a | grep "Deactivating"
    CHECK_RESULT $? 0 0 "Check vdo deactivate -a failed"

    vdo deactivate -n my_vdo_volume | grep "already deactivated"
    CHECK_RESULT $? 0 0 "Check vdo deactivate -n failed"

    vdo deactivate -n my_vdo_volume -f /etc/vdoconf.yml | grep "already deactivated"
    CHECK_RESULT $? 0 0 "Check vdo deactivate -f failed"

    vdo activate -n my_vdo_volume
    vdo deactivate -n my_vdo_volume --logfile /var/log/vdo_deactivate.log | grep "Deactivating VDO"
    CHECK_RESULT $? 0 0 "Check vdo deactivate --logfile failed"

    vdo deactivate --verbose -n my_vdo_volume | grep "already deactivated"
    CHECK_RESULT $? 0 0 "Check vdo deactivate --verbose failed"
    vdo activate -n my_vdo_volume

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_deactivate.log
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
