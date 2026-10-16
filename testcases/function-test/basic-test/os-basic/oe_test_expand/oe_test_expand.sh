#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-06-13
# @License   :   Mulan PSL v2
# @Desc      :   Use expand case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    grep '^MANPATH' /etc/man_db.conf | head -n 3 | cat -A|grep I
    CHECK_RESULT $? 0 0 "Checking whether the tab key exists fails"
    grep '^MANPATH' /etc/man_db.conf | head -n 3 | expand -t 6  | cat -A
    CHECK_RESULT $? 1 1 "Check whether the tab key still exists"
    expand --help|grep expand
    CHECK_RESULT $? 0 0  "check command fail"
    expand --version|grep "expand (GNU coreutils)"
    CHECK_RESULT $? 0 0  "check command fail"    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    LOG_INFO "End to clean the test environment."
}

main "$@"

