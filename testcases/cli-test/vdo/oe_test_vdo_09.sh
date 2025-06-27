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
    touch /var/log/vdo_list.log /var/log/vdo_printConfigFile.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_09."

    vdo list --help | grep "usage: vdo list"
    CHECK_RESULT $? 0 0 "Check vdo list --help failed"

    vdo list -a | grep "my_vdo_volume"
    CHECK_RESULT $? 0 0 "Check vdo list -a failed"

    vdo list --verbose | grep -E "dmsetup status|lsblk"
    CHECK_RESULT $? 0 0 "Check vdo list --verbose failed"

    vdo list -f /etc/vdoconf.yml | grep "my_vdo_volume"
    CHECK_RESULT $? 0 0 "Check vdo list -f failed"

    vdo list --logfile /var/log/vdo_list.log | grep "my_vdo_volume"
    CHECK_RESULT $? 0 0 "Check vdo list --logfile failed"

    vdo printConfigFile --help | grep "usage: vdo printConfigFile"
    CHECK_RESULT $? 0 0 "Check vdo printConfigFile --help failed"

    vdo printConfigFile --verbose | grep "config:"
    CHECK_RESULT $? 0 0 "Check vdo printConfigFile --verbose failed"

    vdo printConfigFile -f /etc/vdoconf.yml | grep "config:"
    CHECK_RESULT $? 0 0 "Check vdo printConfigFile -f failed"

    vdo printConfigFile --logfile /var/log/vdo_printConfigFile.log | grep "config:"
    CHECK_RESULT $? 0 0 "Check vdo printConfigFile --logfile failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_list.log /var/log/vdo_printConfigFile.log
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
