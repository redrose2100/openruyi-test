#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2025-1-13
# @License   :   Mulan PSL v2
# @Desc      :   command lslogins05
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    lslogins -o PWD-METHOD | uniq | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns password encryption method"
    lslogins -o GROUP
    CHECK_RESULT $? 0 0 "output columns primary group name"
    lslogins -o GID
    CHECK_RESULT $? 0 0 "output columns primary group ID"
    lslogins -o SUPP-GROUPS | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns supplementary group names"
    lslogins -o SUPP-GIDS | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns supplementary group IDs"
    lslogins -o LAST-LOGIN | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns date of last login"
    lslogins -o LAST-TTY | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns last tty used"
    lslogins -o LAST-HOSTNAME | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns hostname during the last session"
    lslogins -o FAILED-LOGIN | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns date of last failed login"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
