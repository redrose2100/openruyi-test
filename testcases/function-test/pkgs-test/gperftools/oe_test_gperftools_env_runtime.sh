#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-08
# @License   :   Mulan PSL v2
# @Desc      :   gperftools-Environment variables and runtime features
# ############################################
#shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gperftools gperftools-devel gcc pprof"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Compile with tcmalloc
    gcc -o /tmp/env_test common/env_test.c -ltcmalloc -lprofiler
    CHECK_RESULT $? 0 0 "Failed to compile environment test"

    # Test 2: Test MALLOCSTATS environment variable
    MALLOCSTATS=1 /tmp/env_test 2>&1 | tee /tmp/mallocstats.log
    CHECK_RESULT $? 0 0 "MALLOCSTATS test failed"
    grep -qi "tcmalloc" /tmp/mallocstats.log || grep -qi "in use" /tmp/mallocstats.log || grep -qi "memory" /tmp/mallocstats.log
    CHECK_RESULT $? 0 0 "MALLOCSTATS output invalid"

    # Test 3: Test HEAPPROFILE with allocation interval
    HEAPPROFILE=/tmp/env_heap HEAP_PROFILE_ALLOCATION_INTERVAL=10485760 /tmp/env_test
    CHECK_RESULT $? 0 0 "HEAPPROFILE with interval test failed"
    ls /tmp/env_heap.*.heap > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Heap profile with interval not generated"

    # Test 4: Test CPUPROFILE_FREQUENCY
    CPUPROFILE=/tmp/env_cpu.out CPUPROFILE_FREQUENCY=100 /tmp/env_test
    CHECK_RESULT $? 0 0 "CPUPROFILE_FREQUENCY test failed"
    test -s /tmp/env_cpu.out
    CHECK_RESULT $? 0 0 "CPU profile with frequency not generated"

    # Test 5: Test LD_PRELOAD with tcmalloc_minimal
    gcc -o /tmp/env_test_plain common/env_test.c
    CHECK_RESULT $? 0 0 "Failed to compile plain test program"

    LD_PRELOAD=/usr/lib64/libtcmalloc_minimal.so /tmp/env_test_plain
    CHECK_RESULT $? 0 0 "LD_PRELOAD tcmalloc_minimal test failed"

    # Test 6: Test tcmalloc_minimal debug library exists
    test -f /usr/lib64/libtcmalloc_minimal_debug.so
    CHECK_RESULT $? 0 0 "libtcmalloc_minimal_debug.so not found"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/env_test /tmp/env_test_plain
    rm -rf /tmp/mallocstats.log /tmp/env_heap.*.heap /tmp/env_cpu.out
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
