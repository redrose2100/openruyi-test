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
    LOG_INFO "Start to run testcase:oe_test_vdo_14."

    vdodmeventd --help | grep "OPTIONS"
    CHECK_RESULT $? 0 0 "Check vdodmeventd --help failed"

    vdodmeventd --unregister my_vdo_volume
    CHECK_RESULT $? 0 0 "Check vdodmeventd --unregister failed"

    vdodmeventd --register my_vdo_volume
    CHECK_RESULT $? 0 0 "Check vdodmeventd --register failed"

    vdodmeventd --version | grep "vdodmeventd version"
    CHECK_RESULT $? 0 0 "Check vdodmeventd --version failed"

    vdodumpconfig /dev/loop0 | grep "VDOConfig:"
    CHECK_RESULT $? 0 0 "Check vdodumpconfig failed"

    vdoreadonly /dev/loop0
    CHECK_RESULT $? 0 0 "Check vdoreadonly failed"

    vdoforcerebuild /dev/loop0
    CHECK_RESULT $? 0 0 "Check vdodumpconfig failed"

    if rpm -ql vdo | grep bin | grep vdoprepareupgrade; then
        vdoprepareupgrade /dev/loop0
        CHECK_RESULT $? 0 0 "Check vdoprepareupgrade failed"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
