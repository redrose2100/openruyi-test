#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   dingjiao
#@Contact   	:   15829797643@163.com
#@Date      	:   2022-07-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Verify output readability of perf top
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # `perf` is not a package on openRuyi; the binary ships in linux-tools.
    DNF_INSTALL "linux-tools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    command -v perf
    CHECK_RESULT $? 0 0 "perf is not installed"
    # perf top needs a terminal normally; --stdio keeps it writing to the
    # redirection, and -d bounds the run so the file is flushed.
    perf top --stdio -d 5 >perf.check 2>/dev/null &
    CHECK_RESULT $? 0 0 "perf top:failed"
    SLEEP_WAIT 8
    # Do not hardcode the "kernel" symbol name: the symbol set depends on
    # kallsyms availability and on the sample rate actually achieved. What the
    # case must prove is that perf top produced readable symbol output.
    test -s ./perf.check
    CHECK_RESULT $? 0 0 "perf top produced no output"
    grep -E "^[[:space:]]*[0-9]+\.[0-9]+%" ./perf.check
    CHECK_RESULT $? 0 0 "Verify output readability of perf top:failed!"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf perf.check
    # openRuyi riscv64 无 pgrep：/proc 遍历按 cmdline 匹配 "perf top" 并 kill（等价 pgrep -f "perf top" | xargs -r kill -9；[[ ]] 避免 grep 自匹配）
    for p in /proc/[0-9]*; do [ -r "$p/cmdline" ] || continue; [ "$BASHPID" = "${p#/proc/}" ] && continue; if [[ "$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)" == *'perf top'* ]]; then kill -9 "${p#/proc/}" 2>/dev/null; fi; done
    LOG_INFO "End to restore the test environment."
}

main "$@"
