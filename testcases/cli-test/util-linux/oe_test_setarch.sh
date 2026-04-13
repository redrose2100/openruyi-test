#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   Lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2025-11-24
#@License       :   Mulan PSL v2
#@Desc          :   Test case for setarch command
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "util-linux"
    if ! (find /lib /usr/lib -name "*.so" -exec file {} +) 2>/dev/null | grep -q "32-bit"; then
        LOG_INFO "系统无32位库，跳过setarch 32位切换测试用例"
        exit 255  # 正常退出，标记为跳过
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."
    
    # Test 1: Verify setarch with current architecture returns correct arch
    local current_arch
    current_arch=$(uname -m)
    result=$(setarch "$current_arch" uname -m)
    CHECK_RESULT $? 0 0 "setarch $current_arch uname -m failed"
    
    # Test 2: Verify change arch to 32bit mode, returns correct 32-bit arch
    local expected_32arch
    if [ "$current_arch" == "x86_64" ]; then
        expected_32arch="i686"
    elif [ "$current_arch" == "aarch64" ]; then
        expected_32arch="armv7l"
    elif [ "$current_arch" == "ppc64le" ]; then
        expected_32arch="ppc"
    fi
    if [ "$NODE1_FRAME" != "riscv64" ]; then
        result=$(setarch "$expected_32arch" uname -m)
        CHECK_RESULT $? 0 0 "setarch ${expected_32arch} uname -m failed"
        test "$result" == "$expected_32arch"
        CHECK_RESULT $? 0 0 "the changed arch not equal with expected 32 arch: $expected_32arch"	
    fi    

    # Test 3: Verify invalid architecture returns error
    setarch invalid_arch echo test 2>/dev/null
    CHECK_RESULT $? 0 1 "setarch with invalid arch should exit with non-zero code"
    
    # Test 4: Verify -I option runs without error
    setarch -I echo "test"
    CHECK_RESULT $? 0 0 "setarch -I failed"
    
    # Test 5: Verify -F option runs without error
    setarch -F echo "test"
    CHECK_RESULT $? 0 0 "setarch -F failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
