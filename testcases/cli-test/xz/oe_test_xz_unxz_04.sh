#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2023/07/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in xz package
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL xz
    echo "hello world" >testxz
    xz_version=$(rpm -qa xz | awk -F- '{print $2}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    unxz -z -k -f -vv testxz 2>&1 | grep "Filter chain"
    CHECK_RESULT $? 0 0 "Test failed with option -vv"
    unxz -z -k -f -v testxz 2>&1 | grep "Filter chain"
    CHECK_RESULT $? 1 0 "Test failed with option -v"
    unxz -k -f --info-memory testxz | grep "Memory usage limit"
    CHECK_RESULT $? 0 0 "Test failed with option --info-memory"
    unxz -h | grep -i "Usage: unxz"
    CHECK_RESULT $? 0 0 "Test failed with option -h"
    unxz -H | grep -i -A 10 "Usage: unxz" | grep "long options "
    CHECK_RESULT $? 0 0 "Test failed with option -H"
    unxz -V | grep "${xz_version}"
    CHECK_RESULT $? 0 0 "Test failed with option -V"
    unxz -k -f -M3 --info-memory testxz 2>&1 | grep "3 B" | grep "compression"
    CHECK_RESULT $? 0 0 "Test failed with option -M"
    unxz -qq testxz >testlog 2>&1
    CHECK_RESULT $? 1 0 "Test failed with option -qq"
    test -s testlog
    CHECK_RESULT $? 1 0 "The file is not empty"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf testxz testxz.xz testlog
    LOG_INFO "End to restore the test environment."
}

main "$@"
