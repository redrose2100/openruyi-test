#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wulei
#@Contact   	:   wulei@uniontech.com
#@Date      	:   2023-04-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Basic functional check of libtar package
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL 'libtar libtar-devel'
    touch 1.txt 2.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gcc -o tartest tartest.c -I$HOME/local/include -ltar
    CHECK_RESULT $? 0 0 'Compilation failed'
    test -e tartest
    CHECK_RESULT $? 0 0 'Failed to generate file'
    ./tartest tar
    test -e tartest.tar
    CHECK_RESULT $? 0 0 'Failed to generate tar file'
    ./tartest untar
    CHECK_RESULT $? 0 0 'Package decompression failed'
    test -e test -a -e test/1.txt -a -e test/2.txt
    CHECK_RESULT $? 0 0 '’Incorrect file after decompression'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf 1.txt 2.txt test tartest tartest.tar
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
