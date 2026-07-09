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
# @Author    :   dev
# @Contact   :
# @Date      :   2026-07-08
# @License   :   Mulan PSL v2
# @Desc      :   gperftools-Heap profiler functionality
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    LOG_INFO "No params need to config."
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gperftools gperftools-devel gcc pprof"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Compile with tcmalloc for heap profiling
    gcc -o /tmp/heap_profiler_test common/heap_profiler_test.c -ltcmalloc
    CHECK_RESULT $? 0 0 "Failed to compile with tcmalloc for heap profiling"

    # Test 2: Run with HEAPPROFILE environment variable
    HEAPPROFILE=/tmp/heapprof /tmp/heap_profiler_test
    CHECK_RESULT $? 0 0 "Heap profiler execution failed"

    # Test 3: Verify heap profile files are generated
    ls /tmp/heapprof.*.heap > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Heap profile files not generated"

    # Test 4: Check heap profile file is not empty
    HEAP_FILE=$(ls /tmp/heapprof.*.heap | head -1)
    test -s "$HEAP_FILE"
    CHECK_RESULT $? 0 0 "Heap profile file is empty"

    # Test 5: Analyze heap profile with pprof text output
    pprof --text /tmp/heap_profiler_test "$HEAP_FILE" > /tmp/pprof_heap.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof heap text analysis failed"
    grep -q "Total:" /tmp/pprof_heap.txt
    CHECK_RESULT $? 0 0 "pprof heap text output invalid"

    # Test 6: Check heap profiler header exists
    test -f /usr/include/gperftools/heap-profiler.h
    CHECK_RESULT $? 0 0 "heap-profiler.h header not found"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/heap_profiler_test /tmp/heapprof.*.heap /tmp/pprof_heap.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
