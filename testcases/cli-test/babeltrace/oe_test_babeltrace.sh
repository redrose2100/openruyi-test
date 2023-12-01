#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaomingyang
# @Contact   :   gaomingyang@uniontech.com
# @Date      :   2023-01-12
# @License   :   Mulan PSL v2
# @Desc      :   test babeltrace
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL babeltrace
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    babeltrace --help
    CHECK_RESULT $? 0 0 "babeltrace --help fail"
    babeltrace -l | grep "Formats available: ctf, dummy, lttng-live, ctf-metadata, text"
    CHECK_RESULT $? 0 0 "babeltrace fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE
    LOG_INFO "End to clean the test environment."
}

main "$@"

