#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   LiuZiyi
# @Contact   :   lavandejoey@outlook.com
# @Date      :   2022/4/29
# @Desc      :   Test "--help" "-h" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL autoconf213
    LOG_INFO "Test environment is ready."
}

function run_test() {
    LOG_INFO "Start to run test."

    autoconf-2.13 --help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoconf-2.13 --help run failed"
    autoconf-2.13 -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoconf-2.13 -h run failed"

    autoheader-2.13 --help  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 --help run failed"
    autoheader-2.13 -h  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 -h run failed"

    autoreconf-2.13 --help  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 --help run failed"
    autoreconf-2.13 --h  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 -h run failed"

    autoupdate-2.13 --help  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 --help run failed"
    autoupdate-2.13 --h  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 -h run failed"

    ifnames-2.13 --help  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: ifnames-2.13 --help run failed"
    ifnames-2.13 --h  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: ifnames-2.13 -h run failed"
    LOG_INFO "End to run test."
}

function post_test() {
    DNF_REMOVE autoconf213
    LOG_INFO "Test environment restored."
}

main "$@"
