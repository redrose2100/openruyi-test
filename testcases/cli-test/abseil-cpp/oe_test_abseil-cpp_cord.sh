#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-28
# @License   :   Mulan PSL v2
# @Desc      :   abseil-cpp cord, span, any test
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

    # Test 1: Verify absl::Cord functionality
    cat > /tmp/test_cord.cpp << 'EOF'
#include <iostream>
#include "absl/strings/cord.h"

int main() {
    absl::Cord cord("Hello");
    cord.Append(", World!");
    if (std::string(cord) != "Hello, World!") { std::cerr << "Cord check failed" << std::endl; return 1; }

    std::string long_str(10000, 'x');
    absl::Cord cord2(long_str);
    if (cord2.size() != 10000) { std::cerr << "Large Cord check failed" << std::endl; return 1; }

    std::cout << "Cord test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_cord /tmp/test_cord.cpp -labsl_cord -labsl_cord_internal -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile Cord test"
    /tmp/test_cord | grep -q "Cord test passed"
    CHECK_RESULT $? 0 0 "Cord test failed"

    # Test 2: Verify absl::Span functionality
    cat > /tmp/test_span.cpp << 'EOF'
#include <iostream>
#include <vector>
#include "absl/types/span.h"

int main() {
    std::vector<int> vec = {1, 2, 3, 4, 5};
    absl::Span<int> span(vec);

    if (span.size() != 5) { std::cerr << "Span size failed" << std::endl; return 1; }
    if (span[0] != 1 || span[4] != 5) { std::cerr << "Span access failed" << std::endl; return 1; }

    span[2] = 99;
    if (vec[2] != 99) { std::cerr << "Span modification failed" << std::endl; return 1; }

    std::cout << "Span test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_span /tmp/test_span.cpp -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile Span test"
    /tmp/test_span | grep -q "Span test passed"
    CHECK_RESULT $? 0 0 "Span test failed"

    # Test 3: Verify absl::any functionality
    cat > /tmp/test_any.cpp << 'EOF'
#include <iostream>
#include <string>
#include "absl/types/any.h"

int main() {
    absl::any a = 42;
    if (!a.has_value()) { std::cerr << "any has_value failed" << std::endl; return 1; }

    try {
        if (absl::any_cast<int>(a) != 42) { std::cerr << "any value failed" << std::endl; return 1; }
    } catch (...) { std::cerr << "any cast failed" << std::endl; return 1; }

    a = std::string("Hello, any!");
    try {
        if (absl::any_cast<std::string>(a) != "Hello, any!") { std::cerr << "any string failed" << std::endl; return 1; }
    } catch (...) { std::cerr << "any string cast failed" << std::endl; return 1; }

    std::cout << "any test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_any /tmp/test_any.cpp -labsl_bad_any_cast_impl -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile any test"
    /tmp/test_any | grep -q "any test passed"
    CHECK_RESULT $? 0 0 "any test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_cord.cpp /tmp/test_cord
    rm -f /tmp/test_span.cpp /tmp/test_span
    rm -f /tmp/test_any.cpp /tmp/test_any
    LOG_INFO "End to restore the test environment."
}

main "$@"
