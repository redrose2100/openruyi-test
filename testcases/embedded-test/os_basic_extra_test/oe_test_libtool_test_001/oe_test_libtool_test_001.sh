#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libtool testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run libtool test."

    if ! libtool --help; then 
        LOG_WARN "No libtool in this system, not run the test"
        exit 0
    fi

    libtool --config | grep build_libtool_libs
    CHECK_RESULT $? 0 0 "check libtool --config failed!"
    libtool --features | grep "host:"
    CHECK_RESULT $? 0 0 "check libtool --features failed!"
    libtool --version | grep "GNU libtool"
    CHECK_RESULT $? 0 0 "check libtool --version failed!"
    libtool --help | grep "Usage:"
    CHECK_RESULT $? 0 0 "check libtool --help failed!"
    libtoolize -c 2>&1 | grep "copying"
    CHECK_RESULT $? 0 0 "check libtoolize -c failed!"
    libtoolize -c --debug 2>&1 | grep "enabling shell trace mode"
    CHECK_RESULT $? 0 0 "check libtoolize --debug failed!"
    libtoolize -f 2>&1 | grep "linking"
    CHECK_RESULT $? 0 0 "check libtoolize -f failed!"
    libtoolize -n
    CHECK_RESULT $? 0 0 "check libtoolize -n failed!"
    libtoolize -h | grep "Usage:"
    CHECK_RESULT $? 0 0 "check libtoolize -h failed!"
    libtoolize --version | grep "GNU libtool"
    CHECK_RESULT $? 0 0 "check libtoolize --version failed!"
    libtoolize -i | grep "libtoolize:"
    CHECK_RESULT $? 0 0 "check libtoolize -i failed!"
    libtoolize -i -f -q
    CHECK_RESULT $? 0 0 "check libtoolize -q failed!"
    libtoolize --recursive -f | grep "libtoolize:"
    CHECK_RESULT $? 0 0 "check libtoolize --recursive failed!"
    libtoolize --subproject | grep "libtoolize:"
    CHECK_RESULT $? 0 0 "check libtoolize --subproject failed!"
    libtoolize -v | grep "libtoolize:"
    CHECK_RESULT $? 0 0 "check libtoolize -v failed!"
    libtoolize --no-warnings
    CHECK_RESULT $? 0 0 "check libtoolize --no-warnings failed!"
    LOG_INFO "End to run libtool test."
}

main "$@"
