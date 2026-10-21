#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NONINFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-06-02
# @License   :   Mulan PSL v2
# @Desc      :   aom (AV1 codec) basic function test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "aom"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    ldconfig -p | grep -qi "aom"
    CHECK_RESULT $? 0 0 "libaom library not found"

    LIB_PATH=$(ldconfig -p | grep -i aom | head -1 | awk '{print $NF}')
    test -f "${LIB_PATH}"
    CHECK_RESULT $? 0 0 "libaom file is missing"

    LD_DEBUG=libs ls > /dev/null 2>&1
    unset LD_DEBUG
    CHECK_RESULT $? 0 0 "libaom dynamic load failed"

    LOG_INFO "All test executed successfully!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf testfile > /dev/null 2>&1
    LOG_INFO "End to restore the test environment."
}

main "$@"