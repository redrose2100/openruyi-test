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
# @Desc      :   abseil-cpp strings, status, flags test
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

    # Test 1: Verify absl::string_view functionality
    cat > /tmp/test_string_view.cpp << 'EOF'
#include <iostream>
#include "absl/strings/string_view.h"

int main() {
    absl::string_view sv = "Hello, abseil-cpp!";
    if (sv.size() != 18) { std::cerr << "size check failed" << std::endl; return 1; }
    if (sv != "Hello, abseil-cpp!") { std::cerr << "comparison failed" << std::endl; return 1; }
    std::cout << "string_view test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_string_view /tmp/test_string_view.cpp -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile string_view test"
    /tmp/test_string_view | grep -q "string_view test passed"
    CHECK_RESULT $? 0 0 "string_view test failed"

    # Test 2: Verify absl::StrFormat and StrJoin functionality
    cat > /tmp/test_strings.cpp << 'EOF'
#include <iostream>
#include <vector>
#include "absl/strings/str_format.h"
#include "absl/strings/str_join.h"

int main() {
    std::string formatted = absl::StrFormat("Test %d: %s", 1, "success");
    if (formatted != "Test 1: success") { std::cerr << "StrFormat failed" << std::endl; return 1; }

    std::vector<std::string> items = {"apple", "banana", "cherry"};
    std::string joined = absl::StrJoin(items, ", ");
    if (joined != "apple, banana, cherry") { std::cerr << "StrJoin failed" << std::endl; return 1; }

    std::cout << "strings test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_strings /tmp/test_strings.cpp -labsl_strings -labsl_str_format_internal -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile strings test"
    /tmp/test_strings | grep -q "strings test passed"
    CHECK_RESULT $? 0 0 "strings test failed"

    # Test 3: Verify absl::Status functionality
    cat > /tmp/test_status.cpp << 'EOF'
#include <iostream>
#include "absl/status/status.h"

int main() {
    absl::Status ok = absl::OkStatus();
    if (!ok.ok()) { std::cerr << "OkStatus failed" << std::endl; return 1; }

    absl::Status error = absl::InternalError("test error");
    if (error.ok()) { std::cerr << "error status check failed" << std::endl; return 1; }
    if (error.code() != absl::StatusCode::kInternal) { std::cerr << "error code check failed" << std::endl; return 1; }

    std::cout << "Status test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_status /tmp/test_status.cpp -labsl_status -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile status test"
    /tmp/test_status | grep -q "Status test passed"
    CHECK_RESULT $? 0 0 "Status test failed"

    # Test 4: Verify absl::StatusOr functionality
    cat > /tmp/test_statusor.cpp << 'EOF'
#include <iostream>
#include "absl/status/statusor.h"
#include "absl/status/status.h"

absl::StatusOr<int> Divide(int a, int b) {
    if (b == 0) { return absl::InvalidArgumentError("Division by zero"); }
    return a / b;
}

int main() {
    auto result = Divide(10, 3);
    if (!result.ok() || result.value() != 3) { std::cerr << "StatusOr failed" << std::endl; return 1; }

    auto err_result = Divide(10, 0);
    if (err_result.ok()) { std::cerr << "StatusOr error check failed" << std::endl; return 1; }

    std::cout << "StatusOr test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_statusor /tmp/test_statusor.cpp -labsl_statusor -labsl_status -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile StatusOr test"
    /tmp/test_statusor | grep -q "StatusOr test passed"
    CHECK_RESULT $? 0 0 "StatusOr test failed"

    # Test 5: Verify absl::flags functionality
    cat > /tmp/test_flags.cpp << 'EOF'
#include <iostream>
#include "absl/flags/flag.h"
#include "absl/flags/parse.h"

ABSL_FLAG(int, timeout, 30, "Timeout in seconds");

int main(int argc, char* argv[]) {
    absl::ParseCommandLine(argc, argv);
    if (absl::GetFlag(FLAGS_timeout) != 30) { std::cerr << "flags default failed" << std::endl; return 1; }
    std::cout << "flags test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_flags /tmp/test_flags.cpp -labsl_flags -labsl_flags_parse -labsl_flags_commandlineflag -labsl_flags_config -labsl_flags_internal -labsl_flags_reflection -labsl_flags_marshalling -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile flags test"
    /tmp/test_flags | grep -q "flags test passed"
    CHECK_RESULT $? 0 0 "flags test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_string_view.cpp /tmp/test_string_view
    rm -f /tmp/test_strings.cpp /tmp/test_strings
    rm -f /tmp/test_status.cpp /tmp/test_status
    rm -f /tmp/test_statusor.cpp /tmp/test_statusor
    rm -f /tmp/test_flags.cpp /tmp/test_flags
    LOG_INFO "End to restore the test environment."
}

main "$@"
