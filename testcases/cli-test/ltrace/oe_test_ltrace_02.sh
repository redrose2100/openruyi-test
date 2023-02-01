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
    ltrace -i ./tst 2>&1 | grep -m 1 "[0x[[:xdigit:]]"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -i"
    ltrace -x 'func*' ./tst 2>&1 | grep "func_f_main"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -x" 
    ltrace -e 'func*' ./tst 2>&1 | grep "tst->func_f_lib"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -e" 
    ltrace -l libtst.so ./tst 2>&1 | grep "tst->func_f_lib"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -l" 
    ltrace --library=libtst.so ./tst 2>&1 | grep "tst->func_f_lib"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --library"
    ltrace -r ./tst 2>&1 | grep -m 1 "[[:digit:]]*.[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -r" 
    ltrace -f ./tst 2>&1 | grep -m 1 "pid"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -f" 
    ltrace -t ./tst 2>&1 | grep -m 1 "[[:digit:]]*:[[:digit:]]*:[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -t" 
    ltrace -tt ./tst 2>&1 | grep -m 1 "[[:digit:]]*:[[:digit:]]*:[[:digit:]]*.[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -tt" 
    ltrace -ttt ./tst 2>&1 | grep -m 1 "[[:digit:]]*.[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -ttt" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tst libtst.so
    LOG_INFO "End to restore the test environment."
}

main "$@"