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
# @Date      :   2023-11-19
# @License   :   Mulan PSL v2
# @Desc      :   verification etmem command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "etmem"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    etmemd -h | grep -E "usage|用法"
    CHECK_RESULT $? 0 0 "etmemd -h not found"
    etmemd -s etmemd_socket -l 0 &
    CHECK_RESULT $? 0 0 "etmemd -s etmemd_socket failed"
    kill -9 "$(pgrep -f etmemd_socket)"
    CHECK_RESULT $? 0 0 "kill -9 failed"
    etmemd -s etmemd_socket_test -l 0 -m
    CHECK_RESULT $? 0 0 "etmemd -s etmemd_socket_test failed"
    kill -9 "$(pgrep -f etmemd_socket_test)"
    CHECK_RESULT $? 0 0 "kill etmemd_socket_test failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
