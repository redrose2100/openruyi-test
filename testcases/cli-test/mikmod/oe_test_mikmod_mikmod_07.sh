#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST mikmod options
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    modprobe snd-dummy
    ret=$?
    if [ $ret -ne 0 ] ;then
        LOG_WARN "The current kernel does not have the snd-dummy module."
        exit 255
    fi
    DNF_INSTALL "mikmod"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    echo "Q" | mikmod -hq > /dev/null && grep "HQMIXER = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -hq failed"
    echo "Q" | mikmod -nohq > /dev/null && grep "HQMIXER = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nohq failed"
    echo "Q" | mikmod -hqmixer > /dev/null && grep "HQMIXER = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -hqmixer failed"
    echo "Q" | mikmod -nohqmixer > /dev/null && grep "HQMIXER = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nohqmixer failed"
    echo "Q" | mikmod -su > /dev/null && grep "SURROUND = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -su failed"
    echo "Q" | mikmod -nosu > /dev/null && grep "SURROUND = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nosu failed"
    echo "Q" | mikmod -surround > /dev/null && grep "SURROUND = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -surround failed"
    echo "Q" | mikmod -nosurround > /dev/null && grep "SURROUND = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nosurround failed"
    echo "Q" | mikmod -norc | grep -q "empty" 
    CHECK_RESULT $? 0 0 "Check mikmod -norc failed"
    LOG_INFO "End to run test."
}

# Post-processing, restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    modprobe -r snd-dummy
    rm -rf ~/.mikmod*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"