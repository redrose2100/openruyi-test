#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2023/10/17
#@License   :   Mulan PSL v2
#@Desc      :   Test "intel-cmt-cat" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    if [ "${NODE1_FRAME}" != "x86_64" ]; then
        # 非 x86 架构跳过测试
        LOG_WARN "Testing cannot be performed if NODE1_FRAME not x86_64."
        exit 255
    fi
    DNF_INSTALL "util-linux"
    # 非 intel cpu 跳过测试
    lscpu | grep -i intel || exit 255
    DNF_INSTALL "intel-cmt-cat"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pqos -h | grep -e "Usage: pqos"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    pqos -s | grep -e "L3CA COS definitions"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    pqos -d | grep "Hardware capabilities"
    CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
    pqos -f common/alloc_reset_cat.cfg | grep -e "Allocation reset successful"
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    pqos --version | grep "PQoS Library version:"
    CHECK_RESULT $? 0 0 "L$LINENO: --version No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"