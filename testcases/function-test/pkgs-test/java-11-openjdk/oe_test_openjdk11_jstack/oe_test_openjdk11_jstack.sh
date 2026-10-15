#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-08-01
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11 command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    jstack -h 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "jstack -h failed"
    jrunscript &
    jstack_pid=$! && exit
    jstack -m ${jstack_pid} 2>&1 | grep 'Debugger attached successfully'
    CHECK_RESULT $? 0 0 "jstack -m failed"
    jstat -help | grep Usage
    CHECK_RESULT $? 0 0 "jstat -help failed"
    jstat -gc ${jstack_pid} | grep 'S0C' | grep 'S1C' | grep 'S0U'
    CHECK_RESULT $? 0 0 "jstat -gc failed"
    kill -9 ${jstack_pid}
    CHECK_RESULT $? 0 0 "kill jstack_pid failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
