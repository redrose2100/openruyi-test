#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   QianCheng
# @Contact   :   qiancheng@uniontech.com
# @Date      :   2024-3-18
# @License   :   Mulan PSL v2
# @Desc      :   Supports logging of device information
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "No pkgs need to install."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    systemd-analyze
    CHECK_RESULT $? 0 0 "systemd-analyze execution failed"
    systemd-analyze critical-chain
    CHECK_RESULT $? 0 0 "critical-chain execution failed"
    systemd-analyze blame
    CHECK_RESULT $? 0 0 "blame execution failed"
    systemd-analyze plot > boot-time.svg
    find . -name "boot-time.svg"
    CHECK_RESULT $? 0 0 "plot execution failed"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf boot-time.svg
    LOG_INFO "Finish environment cleanup."
}

main "$@"
