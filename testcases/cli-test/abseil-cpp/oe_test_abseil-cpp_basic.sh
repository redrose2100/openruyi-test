#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-28
# @License   :   Mulan PSL v2
# @Desc      :   abseil-cpp installation and logging test
# ############################################
# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "abseil-cpp abseil-cpp-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify package installation
    rpm -qa | grep -q "abseil-cpp"
    CHECK_RESULT $? 0 0 "abseil-cpp package not installed"

    # Test 2: Verify main library files exist
    ldconfig -p | grep -q "libabsl_base"
    CHECK_RESULT $? 0 0 "libabsl_base library not found"

    # Test 3: Verify log sink library exists
    ldconfig -p | grep -q "libabsl_log_sink"
    CHECK_RESULT $? 0 0 "libabsl_log_sink library not found"

    # Test 4: Verify library file count
    local lib_count=$(ldconfig -p | grep -c "libabsl_")
    [ "$lib_count" -gt 50 ]
    CHECK_RESULT $? 0 0 "abseil-cpp library count is less than expected: $lib_count"

    # Test 5: Verify documentation exists
    [ -f /usr/share/doc/abseil-cpp/README.md ]
    CHECK_RESULT $? 0 0 "abseil-cpp documentation not found"

    # Test 6: Verify license file exists
    [ -f /usr/share/licenses/abseil-cpp/LICENSE ]
    CHECK_RESULT $? 0 0 "abseil-cpp license not found"

    # Test 7: Verify logging functionality
    cat > /tmp/test_logging.cpp << 'EOF'
#include <iostream>
#include "absl/log/log.h"
#include "absl/log/check.h"
#include "absl/log/initialize.h"

int main() {
    absl::InitializeLog();
    LOG(INFO) << "This is an info message";
    LOG(WARNING) << "This is a warning message";
    LOG(ERROR) << "This is an error message";
    CHECK(1 + 1 == 2) << "CHECK should not fail";
    int x = 42;
    CHECK_GT(x, 0) << "x should be positive";
    std::cout << "Logging test passed" << std::endl;
    return 0;
}
EOF

    g++ -std=c++17 -o /tmp/test_logging /tmp/test_logging.cpp \
        -labsl_log_initialize -labsl_log_internal_globals \
        -labsl_log_internal_message -labsl_log_severity \
        -labsl_log_sink -labsl_log_entry \
        -labsl_log_flags -labsl_log_globals \
        -labsl_log_internal_format -labsl_log_internal_check_op \
        -labsl_log_internal_conditions -labsl_log_internal_nullguard \
        -labsl_flags -labsl_flags_parse \
        -labsl_flags_commandlineflag -labsl_flags_config \
        -labsl_flags_internal -labsl_flags_reflection \
        -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile logging test"

    /tmp/test_logging 2>&1 | grep -q "Logging test passed"
    CHECK_RESULT $? 0 0 "Logging test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_logging.cpp /tmp/test_logging
    LOG_INFO "End to restore the test environment."
}

main "$@"
