#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/07/11
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of iptables-save
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iptables
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if df -h / | grep overlay; then
        LOG_INFO "The current environment is Docker."
    else
        systemctl start iptables
        iptables-save -t nat | grep nat
        CHECK_RESULT $? 0 0 "Incomplete display nat"
        iptables-save -t mangle | grep mangle
        CHECK_RESULT $? 0 0 "Incomplete display mangle"
        iptables-save -t raw | grep raw
        CHECK_RESULT $? 0 0 "Incomplete display raw"
        iptables-save -t security | grep security
        CHECK_RESULT $? 0 0 "Incomplete display security"
    fi
    iptables-save | grep filter
    CHECK_RESULT $? 0 0 "Incomplete display filter"
    iptables-save -t filter | grep filter
    CHECK_RESULT $? 0 0 "Failed to display filter"
    iptables-save -t filter | grep -E "nat|mangle|raw|security"
    CHECK_RESULT $? 0 1 "Not just filter"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
