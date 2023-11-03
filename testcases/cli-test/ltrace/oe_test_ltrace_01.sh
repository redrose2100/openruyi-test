# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   zu binshuo
# @Contact   	:   binshuo@isrc.iscas.ac.cn
# @Date      	:   2022-7-15
# @License   	:   Mulan PSL v2
# @Desc      	:   the test of ltrace package
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ltrace gcc"
    gcc ./common/tstlib.c -shared -fPIC -o libtst.so
    gcc -o tst ./common/tst.c -L. -Wl,-rpath=. -ltst
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing."
    ltrace -h 2>&1 | grep "Usage: ltrace"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -h"
    ltrace --help 2>&1 | grep "Usage: ltrace"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --help"
    ltrace -V 2>&1 | grep "ltrace [[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -V"
    ltrace --version 2>&1 | grep "ltrace [[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --version"
    ltrace -T ./tst 2>&1 | grep -m 1 "<[[:digit:]]*.[[:digit:]]*>"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -T"
    ltrace -S ./tst 2>&1 | grep -m 1 "SYS"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -S"
    ltrace -D 77 ./tst 2>&1 | grep -m 1 "DEBUG"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -D"
    ltrace --debug 77 ./tst 2>&1 | grep -m 1 "DEBUG"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --debug" 
    ltrace -Dh 2>&1 | grep "debugging option"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -Dh" 
    ltrace --debug=help 2>&1 | grep "debugging option"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --debug=help"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tst libtst.so
    LOG_INFO "End to restore the test environment."
}

main "$@"