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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    unxz -z -0 -k -f -vv testxz 2>&1 | grep dict=256KiB
    CHECK_RESULT $? 0 0 "Compression level 0 setting failed"
    unxz -z -1 -k -f -vv testxz 2>&1 | grep dict=1MiB
    CHECK_RESULT $? 0 0 "Compression level 1 setting failed"
    unxz -z -2 -k -f -vv testxz 2>&1 | grep dict=2MiB
    CHECK_RESULT $? 0 0 "Compression level 2 setting failed"
    unxz -z -3 -k -f -vv testxz 2>&1 | grep dict=4MiB | grep nice=273
    CHECK_RESULT $? 0 0 "Compression level 3 setting failed"
    unxz -z -4 -k -f -vv testxz 2>&1 | grep dict=4MiB | grep nice=16
    CHECK_RESULT $? 0 0 "Compression level 4 setting failed"
    unxz -z -5 -k -f -vv testxz 2>&1 | grep dict=8MiB | grep nice=32
    CHECK_RESULT $? 0 0 "Compression level 5 setting failed"
    unxz -z -6 -k -f -vv testxz 2>&1 | grep dict=8MiB | grep nice=64
    CHECK_RESULT $? 0 0 "Compression level 6 setting failed"
    unxz -z -7 -k -f -vv testxz 2>&1 | grep dict=16MiB
    CHECK_RESULT $? 0 0 "Compression level 7 setting failed"
    unxz -z -8 -k -f -vv testxz 2>&1 | grep dict=32MiB
    CHECK_RESULT $? 0 0 "Compression level 8 setting failed"
    unxz -z -9 -k -f -vv testxz 2>&1 | grep dict=64MiB
    CHECK_RESULT $? 0 0 "Compression level 9 setting failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf testxz testxz.xz
    LOG_INFO "End to restore the test environment."
}

main "$@"
