#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2024/08/22
# @License   :   Mulan PSL v2
# @Desc      :   Ionice sets IO scheduling and priority testing for processes
# #############################################

#!/usr/bin/bash

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    dd if=/dev/zero of=/dev/null &
    TEST_PID=$!
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    LOG_INFO "Test 1: View IO priority"
    ionice -p $TEST_PID
    CHECK_RESULT $? 0 0 "View priority failed"
    LOG_INFO "Test 2: Set Best-effort priority 4"
    ionice -c 2 -n 4 -p $TEST_PID
    CHECK_RESULT $? 0 0 "Set priority failed"
    ionice -p $TEST_PID | grep "best-effort.*prio 4"
    CHECK_RESULT $? 0 0 "Priority verification failed"
    LOG_INFO "Test 3: Set Idle class"
    ionice -c 3 -p $TEST_PID
    CHECK_RESULT $? 0 0 "Set idle class failed"
    ionice -p $TEST_PID | grep "idle"
    CHECK_RESULT $? 0 0 "Idle class verification failed"
    LOG_INFO "Test 4: Invalid parameter test"
    ionice -c 2 -n 8 -p $TEST_PID 2>/dev/null
    CHECK_RESULT $? 1 1 "Priority 8 should be rejected"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    kill -9 $TEST_PID 2>/dev/null
    export LANG="$OLD_LANG"
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

