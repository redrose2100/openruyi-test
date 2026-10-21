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
# @Date      :   2023/09/20
# @License   :   Mulan PSL v2
# @Desc      :   Test vdo
# #############################################
# shellcheck disable=SC1091
source "common/common_vdo.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    touch /var/log/vdo_create.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_create_01."

    vdo create --help | grep "usage: vdo create"
    CHECK_RESULT $? 0 0 "Check vdo create --help failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create -n failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --verbose | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --verbose failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 -f /etc/vdoconf.yml | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create -f failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --logfile /var/log/vdo_create.log | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --logfile failed"
    sudo rm /var/log/vdo_create.log

    if vdo create -h | grep "writePolicy"; then
        vdo create -n my_vdo_volume --device /dev/loop0 --writePolicy auto | grep "Creating"
        CHECK_RESULT $? 0 0 "Check vdo create --writePolicy failed"
        vdo remove -n my_vdo_volume
    fi

    vdo create -n my_vdo_volume --device /dev/loop0 | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --device failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --activate enabled | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --activate failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --blockMapCacheSize 128M | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --blockMapCacheSize failed"
    vdo remove -n my_vdo_volume

    vdo create -n my_vdo_volume --device /dev/loop0 --compression enabled | grep "Creating"
    CHECK_RESULT $? 0 0 "Check vdo create --compression failed"
    vdo remove -n my_vdo_volume

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
