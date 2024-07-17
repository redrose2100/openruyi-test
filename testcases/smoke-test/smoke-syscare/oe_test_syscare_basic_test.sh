#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linmengmeng
#@Contact       :   linmengmeng@huawei.com
#@Date          :   2024-07-17
#@License       :   Mulan PSL v2
#@Desc          :   Pressure load : concurrent operations
#####################################
# shellcheck disable=SC1091

source "common/common_syscare.sh"

function pre_test() {
    init_env
}

function run_test() {
    # 当前syscare制作补丁需要真实src源码包和对应debuginfo包，本用例仅验证syscare安装和命令行功能正常
    LOG_INFO "Start to run test."
    syscare list
    CHECK_RESULT $?
    syscare -h
    CHECK_RESULT $?
    syscare -V
    CHECK_RESULT $?
    syscare save
    CHECK_RESULT $?
    syscare restore
    CHECK_RESULT $?
    syscare build -h
    CHECK_RESULT $?
    syscare build -V
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "test end"
}

main "$@"
