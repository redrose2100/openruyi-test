#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
#############################################
#@Author        :   yangxi
#@Contact       :   yangxi@uiontech.com
#@Date          :   2026/04/13
#@License       :   Mulan PSL v2
#@Desc          :   Test hyperscan simplegrep
##############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hyperscan hyperscan-devel gcc"
    cp -r /usr/include /usr/include_bak
    cp /usr/include/hs/* /usr/include/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /usr/share/doc/hyperscan/examples || {
        LOG_ERROR "Failed to cd to /usr/share/doc/hyperscan/examples"
        return 1
    }
    gcc -o simplegrep simplegrep.c -lhs -lm
    CHECK_RESULT $? 0 0 "Compile simplegrep failed"
    test -f simplegrep
    CHECK_RESULT $? 0 0 "simplegrep binary not found after compilation"
    LOG_INFO "Test point 1: Test simplegrep multiple patterns matching."
    ./simplegrep '(File|include|return)' pcapscan.cc > /dev/null
    CHECK_RESULT $? 0 0 "simplegrep multiple patterns matching failed"
    LOG_INFO "Test point 2: Test simplegrep number pattern matching."
    ./simplegrep '[0-9]' pcapscan.cc > /dev/null
    CHECK_RESULT $? 0 0 "simplegrep number pattern matching failed"
    LOG_INFO "Test point 3: Test simplegrep line start pattern matching."
    ./simplegrep '^#' pcapscan.cc > /dev/null
    CHECK_RESULT $? 0 0 "simplegrep line start pattern matching failed"
    LOG_INFO "Test point 4: Test simplegrep case-sensitive pattern matching."
    ./simplegrep 'File' pcapscan.cc > /dev/null
    CHECK_RESULT $? 0 0 "simplegrep case-sensitive pattern matching failed"
    LOG_INFO "Test point 5: Test simplegrep help information."
    ./simplegrep --help 2>&1 | grep -E "usage|Usage|help"
    CHECK_RESULT $? 0 0 "simplegrep help information query failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd /tmp
    # shellcheck disable=SC2119 
    DNF_REMOVE "hyperscan hyperscan-devel gcc"
    rm -rf /usr/include_bak
    LOG_INFO "End to restore the test environment."
}

main "$@"

