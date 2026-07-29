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
# @Desc      :   abseil-cpp container and int128 test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "abseil-cpp abseil-cpp-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify absl::flat_hash_map functionality
    cat > /tmp/test_hashmap.cpp << 'EOF'
#include <iostream>
#include "absl/container/flat_hash_map.h"

int main() {
    absl::flat_hash_map<std::string, int> map;

    map["one"] = 1; map["two"] = 2; map["three"] = 3;
    if (map.size() != 3) { std::cerr << "HashMap size failed" << std::endl; return 1; }

    if (map.find("two") == map.end() || map["two"] != 2) { std::cerr << "HashMap find failed" << std::endl; return 1; }

    map.erase("one");
    if (map.size() != 2) { std::cerr << "HashMap erase failed" << std::endl; return 1; }

    map["two"] = 22;
    if (map["two"] != 22) { std::cerr << "HashMap modify failed" << std::endl; return 1; }

    std::cout << "HashMap test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_hashmap /tmp/test_hashmap.cpp -labsl_hash -labsl_raw_hash_set -labsl_low_level_hash -labsl_raw_logging_internal -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile HashMap test"
    /tmp/test_hashmap | grep -q "HashMap test passed"
    CHECK_RESULT $? 0 0 "HashMap test failed"

    # Test 2: Verify absl::flat_hash_set functionality
    cat > /tmp/test_hashset.cpp << 'EOF'
#include <iostream>
#include "absl/container/flat_hash_set.h"

int main() {
    absl::flat_hash_set<std::string> set;

    set.insert("apple"); set.insert("banana"); set.insert("cherry");
    if (set.size() != 3) { std::cerr << "HashSet size failed" << std::endl; return 1; }

    if (set.find("banana") == set.end()) { std::cerr << "HashSet find failed" << std::endl; return 1; }
    if (set.find("grape") != set.end()) { std::cerr << "HashSet not-found failed" << std::endl; return 1; }

    set.insert("apple");
    if (set.size() != 3) { std::cerr << "HashSet duplicate failed" << std::endl; return 1; }

    set.erase("apple");
    if (set.size() != 2) { std::cerr << "HashSet erase failed" << std::endl; return 1; }

    std::cout << "HashSet test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_hashset /tmp/test_hashset.cpp -labsl_hash -labsl_raw_hash_set -labsl_low_level_hash -labsl_raw_logging_internal -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile HashSet test"
    /tmp/test_hashset | grep -q "HashSet test passed"
    CHECK_RESULT $? 0 0 "HashSet test failed"

    # Test 3: Verify absl::int128 functionality
    cat > /tmp/test_int128.cpp << 'EOF'
#include <iostream>
#include "absl/numeric/int128.h"

int main() {
    absl::int128 a(100), b(200);

    if (a + b != 300) { std::cerr << "int128 add failed" << std::endl; return 1; }
    if (b - a != 100) { std::cerr << "int128 sub failed" << std::endl; return 1; }
    if (a * b != 20000) { std::cerr << "int128 mul failed" << std::endl; return 1; }
    if ((a * b) / a != b) { std::cerr << "int128 div failed" << std::endl; return 1; }

    // Test large values
    absl::int128 big(1);
    big <<= 70;
    if (big / 2 != (big >> 1)) { std::cerr << "Large int128 failed" << std::endl; return 1; }

    std::cout << "int128 test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_int128 /tmp/test_int128.cpp -labsl_int128 -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile int128 test"
    /tmp/test_int128 | grep -q "int128 test passed"
    CHECK_RESULT $? 0 0 "int128 test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_hashmap.cpp /tmp/test_hashmap
    rm -f /tmp/test_hashset.cpp /tmp/test_hashset
    rm -f /tmp/test_int128.cpp /tmp/test_int128
    LOG_INFO "End to restore the test environment."
}

main "$@"