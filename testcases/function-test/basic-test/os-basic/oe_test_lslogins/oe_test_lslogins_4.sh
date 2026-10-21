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
# @Date      :   2024-8-23
# @License   :   Mulan PSL v2
# @Desc      :   command lslogins04
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
    lslogins -o USER
    CHECK_RESULT $? 0 0 "output columns user name"
    lslogins -o UID
    CHECK_RESULT $? 0 0 "output columns user ID"
    lslogins -o GECOS | grep -v "^$"
    CHECK_RESULT $? 0 0 "output columns full user name"
    lslogins -o HOMEDIR
    CHECK_RESULT $? 0 0 "output columns home directory"
    lslogins -o SHELL | uniq
    CHECK_RESULT $? 0 0 "output columns login shell"
    lslogins -o NOLOGIN | uniq
    CHECK_RESULT $? 0 0 "output columns log in disabled by nologin(8) or pam_nologin(8)
"
    lslogins -o PWD-LOCK | uniq
    CHECK_RESULT $? 0 0 "output columns password defined, but locked"
    lslogins -o PWD-EMPTY | uniq
    CHECK_RESULT $? 0 0 "output columns password not defined"
    lslogins -o PWD-DENY | uniq
    CHECK_RESULT $? 0 0 "output columns login by password disabled"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
