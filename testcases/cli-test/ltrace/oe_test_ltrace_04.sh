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
    ltrace -a 15 -F ./common/ltrace.conf ./tst 2>&1 | grep "func_f_lib()  ="
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -a"
    ltrace --align=15 -F ./common/ltrace.conf ./tst 2>&1 | grep "func_f_lib()  ="
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --align"
    ltrace -o test_o.log ./tst
    test -f test_o.log
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -o"
    ltrace --output=test_output.log ./tst
    test -f test_output.log
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --output"
    ltrace -w 1 ./tst 2>&1 | grep "> tst"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -w"
    ltrace --where=1 ./tst 2>&1 | grep "> tst"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --where"
    ltrace -s 1 bash ls ./common 2>&1 | grep -m 1 "\"t\""
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -s"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf *.log tst libtst.so
    LOG_INFO "End to restore the test environment."
}

main "$@"
