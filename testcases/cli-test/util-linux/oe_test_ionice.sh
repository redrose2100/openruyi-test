#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2024/08/22
# @License   :   Mulan PSL v2
# @Desc      :   Ionice sets IO scheduling and priority testing for processes
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    nohup sleep 60 &
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    PID=$(pgrep -f "sleep 60")
    ionice  -p "$PID" | grep "prio 0"
    CHECK_RESULT $? 0 0 "The priority of the sleep process is not 0"
    ionice -c 2 -n 4 -p "$PID"
    CHECK_RESULT $? 0 0 "Failed to set priority for sleep process"
    ionice  -p "$PID" | grep "prio 4"
    CHECK_RESULT $? 0 0 "The priority of the sleep process is not 4"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    pgrep -f "sleep 60" | xargs kill -9
    export LANG="$OLD_LANG"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
