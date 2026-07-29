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
# @Desc      :   abseil-cpp time and timezone test
# ############################################
# shellcheck disable=SC1090,SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "abseil-cpp abseil-cpp-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify absl::Time and Duration functionality
    cat > /tmp/test_time.cpp << 'EOF'
#include <iostream>
#include "absl/time/time.h"
#include "absl/time/clock.h"

int main() {
    if (absl::Seconds(5) != absl::Milliseconds(5000)) {
        std::cerr << "Duration comparison failed" << std::endl;
        return 1;
    }

    absl::Time t1 = absl::Now();
    absl::Time t2 = absl::Now();
    if (t2 < t1) { std::cerr << "Time ordering failed" << std::endl; return 1; }

    auto diff = (t1 + absl::Seconds(10)) - t1;
    if (diff != absl::Seconds(10)) { std::cerr << "Time arithmetic failed" << std::endl; return 1; }

    auto chrono_d = absl::ToChronoMilliseconds(absl::Seconds(5));
    if (chrono_d.count() != 5000) { std::cerr << "ToChronoMilliseconds failed" << std::endl; return 1; }

    std::cout << "Time test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_time /tmp/test_time.cpp -labsl_time -labsl_strings -labsl_string_view -labsl_base
    CHECK_RESULT $? 0 0 "Failed to compile time test"
    /tmp/test_time | grep -q "Time test passed"
    CHECK_RESULT $? 0 0 "Time test failed"

    # Test 2: Verify absl::TimeZone functionality
    cat > /tmp/test_timezone.cpp << 'EOF'
#include <iostream>
#include <string>
#include "absl/time/time.h"
#include "absl/time/clock.h"

int main() {
    absl::TimeZone tz = absl::LocalTimeZone();
    std::string tz_name = tz.name();
    if (tz_name.empty()) { std::cerr << "TimeZone name check failed" << std::endl; return 1; }

    absl::Time now = absl::Now();
    if (now == absl::Time()) { std::cerr << "Current time check failed" << std::endl; return 1; }

    std::cout << "TimeZone test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_timezone /tmp/test_timezone.cpp -labsl_time_zone -labsl_time -labsl_strings -labsl_string_view -labsl_base
    CHECK_RESULT $? 0 0 "Failed to compile timezone test"
    /tmp/test_timezone | grep -q "TimeZone test passed"
    CHECK_RESULT $? 0 0 "TimeZone test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_time.cpp /tmp/test_time
    rm -f /tmp/test_timezone.cpp /tmp/test_timezone
    LOG_INFO "End to restore the test environment."
}

main "$@"
