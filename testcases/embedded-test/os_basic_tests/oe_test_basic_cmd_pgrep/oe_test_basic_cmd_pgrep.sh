#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-05-09
# @License   :   Mulan PSL v2
# @Desc      :   View process status-pgrep
# ############################################

# shellcheck disable=SC1091
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    pgrep -l ssh
    CHECK_RESULT $? 0 0 "pgrep -l ssh fail"

    pgrep -o ssh
    CHECK_RESULT $? 0 0 "pgrep -o ssh fail"

    pgrep -n ssh
    CHECK_RESULT $? 0 0 "pgrep -n ssh fail"

    pgrep -f sshd
    CHECK_RESULT $? 0 0 "pgrep -f sshd fail"

    oldest_pid=$(pgrep -o ssh)
    pgrep -l -o ssh | grep "${oldest_pid}"
    CHECK_RESULT $? 0 0 "check pgrep -l -o ssh fail"

    newest_pid=$(pgrep -n ssh)
    pgrep -l -n ssh | grep "${newest_pid}"
    CHECK_RESULT $? 0 0 "check pgrep -l -n ssh fail"

    LOG_INFO "End to run test."
}

main "$@"
