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
# @Desc      :   gperftools-pprof analysis tool with various output formats
# #############################################
#shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gperftools gperftools-devel gcc pprof"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Compile test program with -O0 to prevent optimization
    gcc -O0 -o /tmp/pprof_test common/pprof_test.c -lprofiler -ltcmalloc
    CHECK_RESULT $? 0 0 "Failed to compile pprof test program"

    # Test 2: Generate CPU profile
    CPUPROFILE=/tmp/pprof_cpu.out /tmp/pprof_test
    CHECK_RESULT $? 0 0 "CPU profile generation failed"

    # Test 3: pprof --text analysis
    pprof --text /tmp/pprof_test /tmp/pprof_cpu.out > /tmp/pprof_cpu_text.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof --text analysis failed"
    grep -q "Total:" /tmp/pprof_cpu_text.txt
    CHECK_RESULT $? 0 0 "pprof --text output invalid"

    # Test 4: pprof --list analysis
    pprof --list func_a /tmp/pprof_test /tmp/pprof_cpu.out > /tmp/pprof_cpu_list.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof --list analysis failed"

    # Test 5: pprof --disasm analysis
    pprof --disasm func_a /tmp/pprof_test /tmp/pprof_cpu.out > /tmp/pprof_cpu_disasm.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof --disasm analysis failed"

    # Test 6: pprof --callgrind output
    pprof --callgrind /tmp/pprof_test /tmp/pprof_cpu.out > /tmp/pprof_cpu_callgrind.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof --callgrind output failed"

    # Test 7: pprof --raw output
    pprof --raw /tmp/pprof_test /tmp/pprof_cpu.out > /tmp/pprof_cpu_raw.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof --raw output failed"

    # Test 8: pprof --help shows usage
    pprof --help > /tmp/pprof_help.txt 2>&1
    CHECK_RESULT $? 0 0 "pprof --help failed"
    grep -qi "usage" /tmp/pprof_help.txt
    CHECK_RESULT $? 0 0 "pprof help output invalid"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/pprof_test /tmp/pprof_cpu.out
    rm -rf /tmp/pprof_cpu_text.txt /tmp/pprof_cpu_list.txt
    rm -rf /tmp/pprof_cpu_disasm.txt /tmp/pprof_cpu_callgrind.txt /tmp/pprof_cpu_raw.txt /tmp/pprof_help.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
