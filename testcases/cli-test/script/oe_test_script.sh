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
#@Desc          :   Test case for script command
#####################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "util-linux"
    mkdir -p /tmp/test_script
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test default log output
    script -c "echo default_test" /tmp/test_script/default.log
    CHECK_RESULT $? 0 0 "Failed to run script with default output"
    grep "default_test" /tmp/test_script/default.log
    CHECK_RESULT $? 0 0 "Default log missing expected output"
    
    # Test --log-in option
    echo "input_test" | script --log-in /tmp/test_script/in.log -c "cat > /dev/null"
    CHECK_RESULT $? 0 0 "Failed to run script with --log-in"
    grep "input_test" /tmp/test_script/in.log
    CHECK_RESULT $? 0 0 "Input log missing expected data"
    
    # Test --log-out option
    script --log-out /tmp/test_script/out.log -c "echo output_test"
    CHECK_RESULT $? 0 0 "Failed to run script with --log-out"
    grep "output_test" /tmp/test_script/out.log
    CHECK_RESULT $? 0 0 "Output log missing expected data"
    
    # Test --log-io option
    echo "io_input" | script --log-io /tmp/test_script/io.log -c "cat"
    CHECK_RESULT $? 0 0 "Failed to run script with --log-io"
    grep "io_input" /tmp/test_script/io.log
    CHECK_RESULT $? 0 0 "IO log missing input data"
    grep "io_input" /tmp/test_script/io.log | grep -v "io_input" >/dev/null
    CHECK_RESULT $? 1 0 "IO log contains duplicate entries"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_script
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
