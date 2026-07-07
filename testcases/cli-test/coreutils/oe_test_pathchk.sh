#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-03-14
#@License       :   Mulan PSL v2
#@Desc          :   Test case for pathchk command
#####################################
# shellcheck disable=SC1090,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL coreutils
    touch normal_file
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pathchk normal_file
    CHECK_RESULT $? 0 0 "Failed basic file check"
    pathchk -p "invalid:file"
    CHECK_RESULT $? 1 0 "Failed colon check with -p"
    pathchk -P ""
    CHECK_RESULT $? 1 0 "Failed empty filename check with -P"
    pathchk -P "-leadinghyphen"
    CHECK_RESULT $? 1 0 "Failed leading hyphen check with -P"
    pathchk --portability "too_long_$(printf '%*s' 200 '' | tr ' ' 'x')"
    CHECK_RESULT $? 1 0 "Failed long filename check with --portability"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f normal_file
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
