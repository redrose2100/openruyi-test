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
    touch /var/log/vdo_changeWritePolicy.log
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo_02."

    if vdo --help | grep "changeWritePolicy"; then
        vdo changeWritePolicy -h | grep "usage: vdo changeWritePolicy"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -h failed"

        vdo changeWritePolicy -a --writePolicy auto
        vdo status -n my_vdo_volume | grep "Configured write policy: auto"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -a failed"

        vdo changeWritePolicy -n my_vdo_volume --writePolicy sync
        vdo status -n my_vdo_volume | grep "Configured write policy: sync"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -n failed"

        vdo changeWritePolicy -a --writePolicy async --verbose | grep "vdo my_vdo_volume"
        vdo status -n my_vdo_volume | grep "Configured write policy: async"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy --verbose failed"

        vdo changeWritePolicy -a --writePolicy auto -f /etc/vdoconf.yml
        vdo status -n my_vdo_volume | grep "Configured write policy: auto"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -f failed"

        vdo changeWritePolicy -a --writePolicy sync --logfile /var/log/vdo_changeWritePolicy.log
        vdo status -n my_vdo_volume | grep "Configured write policy: sync"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy --logfile failed"

        vdo changeWritePolicy -a --writePolicy auto
        vdo status -n my_vdo_volume | grep "Configured write policy: auto"
        CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy --writePolicy failed"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sudo rm /var/log/vdo_changeWritePolicy.log
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
