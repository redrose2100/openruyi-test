#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run strace testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    strace ls 2>&1 | grep "exited with 0"
    CHECK_RESULT $? 0 0 "check strace ls fail"
    strace -e trace=open,read ls 2>&1 | grep "exited with 0"
    CHECK_RESULT $? 0 0 "check strace -e fail"
    strace -u root ls 2>&1 | grep "exited with 0"
    CHECK_RESULT $? 0 0 "check strace -u fail"
    sleep 5 &
    strace -p $! 2>&1 | grep "Process $! attached"
    CHECK_RESULT $? 0 0 "check strace -p fail"
    strace -o tmptest ls && grep "/bin/ls" tmptest
    CHECK_RESULT $? 0 0 "check strace -o fail"
    strace -t ls 2>&1 | grep "[0-9]*:[0-9]*:[0-9]*"
    CHECK_RESULT $? 0 0 "check strace -t fail"
    strace -f ls 2>&1 | grep "exited with 0"
    CHECK_RESULT $? 0 0 "check strace -f fail"
    strace -c ls 2>&1 | grep "% time"
    CHECK_RESULT $? 0 0 "check strace -c fail"
    strace -x ls 2>&1 | grep "x00"
    CHECK_RESULT $? 0 0 "check strace -x fail"
    if uname -a | grep "aarch64"; then
        strace -i ls 2>&1 | grep "\[0000"
    else
        strace -i ls 2>&1 | grep "\["
    fi
    CHECK_RESULT $? 0 0 "check strace -i fail"
    strace -n pwd 2>&1 | grep "\[  .*\]"
    CHECK_RESULT $? 0 0 "check strace -n fail"

    sleep 5 &
    strace -t -p $! -o tmptest.$!
    sleep 5 &
    strace -t -p $! -o tmptest.$!
    sleep 5 &
    strace -t -p $! -o tmptest.$!
    num=$(strace-log-merge tmptest 2>&1 | grep -c "exited with 0")
    CHECK_RESULT "$num" 3 0 "check strace -n fail"
    LOG_INFO "End of the test."
}

main "$@"
