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
# @Desc      :   abseil-cpp synchronization test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "abseil-cpp abseil-cpp-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify absl::Mutex multi-threading
    cat > /tmp/test_mutex.cpp << 'EOF'
#include <iostream>
#include <thread>
#include <vector>
#include "absl/synchronization/mutex.h"

int main() {
    absl::Mutex mutex;
    int counter = 0;
    const int num_threads = 4;
    const int iterations = 1000;

    std::vector<std::thread> threads;
    for (int i = 0; i < num_threads; ++i) {
        threads.emplace_back([&]() {
            for (int j = 0; j < iterations; ++j) {
                absl::MutexLock lock(&mutex);
                counter++;
            }
        });
    }

    for (auto& t : threads) { t.join(); }

    if (counter != num_threads * iterations) {
        std::cerr << "Mutex counter failed: " << counter << std::endl;
        return 1;
    }

    std::cout << "Mutex test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_mutex /tmp/test_mutex.cpp -labsl_synchronization -labsl_base -lpthread 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile mutex test"
    /tmp/test_mutex | grep -q "Mutex test passed"
    CHECK_RESULT $? 0 0 "Mutex test failed"

    # Test 2: Verify absl::Notification functionality
    cat > /tmp/test_notification.cpp << 'EOF'
#include <iostream>
#include <thread>
#include "absl/synchronization/notification.h"

int main() {
    absl::Notification notification;
    bool worker_done = false;

    std::thread worker([&]() {
        notification.WaitForNotification();
        worker_done = true;
    });

    notification.Notify();
    worker.join();

    if (!worker_done) { std::cerr << "Notification test failed" << std::endl; return 1; }
    std::cout << "Notification test passed" << std::endl;
    return 0;
}
EOF
    g++ -std=c++17 -o /tmp/test_notification /tmp/test_notification.cpp -labsl_synchronization -labsl_base -lpthread 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to compile notification test"
    /tmp/test_notification | grep -q "Notification test passed"
    CHECK_RESULT $? 0 0 "Notification test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_mutex.cpp /tmp/test_mutex
    rm -f /tmp/test_notification.cpp /tmp/test_notification
    LOG_INFO "End to restore the test environment."
}

main "$@"