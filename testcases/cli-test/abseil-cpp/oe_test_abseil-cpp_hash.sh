#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
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
# @Desc      :   abseil-cpp hash and random test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "abseil-cpp abseil-cpp-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify absl::Hash functionality
    cat > /tmp/test_hash.cpp << 'EOF'
#include <iostream>
#include "absl/hash/hash.h"
#include "absl/strings/string_view.h"

int main() {
    absl::Hash<int> hasher;
    if (hasher(42) != hasher(42)) { std::cerr << "Hash consistency failed" << std::endl; return 1; }
    if (hasher(1) == hasher(2)) { std::cerr << "Hash uniqueness failed" << std::endl; return 1; }

    absl::Hash<std::string> str_hasher;
    if (str_hasher("hello") == 0) { std::cerr << "String hash failed" << std::endl; return 1; }

    std::cout << "Hash test passed" << std::endl;
    return 0;
}
EOF
    g++ -o /tmp/test_hash /tmp/test_hash.cpp -labsl_hash -labsl_low_level_hash -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile hash test"
    /tmp/test_hash | grep -q "Hash test passed"
    CHECK_RESULT $? 0 0 "Hash test failed"

    # Test 2: Verify absl random number generation
    cat > /tmp/test_random.cpp << 'EOF'
#include <iostream>
#include <vector>
#include <algorithm>
#include "absl/random/random.h"
#include "absl/random/distributions.h"

int main() {
    absl::BitGen gen;

    // Test uniform distribution
    for (int i = 0; i < 100; ++i) {
        int val = absl::Uniform(gen, 1, 100);
        if (val < 1 || val >= 100) { std::cerr << "Uniform range failed" << std::endl; return 1; }
    }

    // Test random distribution
    std::vector<int> values;
    for (int i = 0; i < 1000; ++i) {
        values.push_back(absl::Uniform(gen, 0, 1000));
    }
    std::sort(values.begin(), values.end());
    auto last = std::unique(values.begin(), values.end());
    if (last - values.begin() < 100) { std::cerr << "Randomness check failed" << std::endl; return 1; }

    std::cout << "Random test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_random /tmp/test_random.cpp -labsl_random_distributions -labsl_random_internal_platform -labsl_random_internal_randen -labsl_random_internal_randen_slow -labsl_random_internal_seed_material -labsl_random_seed_sequences -labsl_random_seed_gen_exception -labsl_random_internal_randen_hwaes -labsl_random_internal_randen_hwaes_impl -labsl_random_internal_pool_urbg -labsl_strings -labsl_string_view -labsl_base 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile random test"
    /tmp/test_random | grep -q "Random test passed"
    CHECK_RESULT $? 0 0 "Random test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_hash.cpp /tmp/test_hash
    rm -f /tmp/test_random.cpp /tmp/test_random
    LOG_INFO "End to restore the test environment."
}

main "$@"