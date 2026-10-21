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
# @Author    :   jiangchenyang
# @Contact   :   jiangcy1129@163.com
# @Date      :   2023-08-10
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -g -o valgrind_test ./common/valgrind_test_03.cpp
    g++ -g -o valgrind_test_fork ./common/valgrind_test_04.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind -q ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind -q error" 
    valgrind --quiet ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --quiet error" 
    valgrind -v ./valgrind_test > valgrind_test.log 2>&1
    grep "Valgrind options:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind -v error" 
    valgrind --verbose ./valgrind_test > valgrind_test.log 2>&1
    grep "Valgrind options:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --verbose error" 
    valgrind --trace-children=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Child process:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --trace-children error" 
    valgrind --trace-children=yes  --trace-children-skip=* ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-children-skip error" 
    valgrind --trace-children=yes  --trace-children-skip-by-arg=* ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-children-skip-by-arg error"  
    valgrind --child-silent-after-fork=yes ./valgrind_test_fork
    CHECK_RESULT $? 0 0 "execute valgrind --child-silent-after-fork error"
    valgrind --vgdb=no --vgdb-error=1 ./valgrind_test_fork
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb error" 
    valgrind --vgdb-error=1 ./valgrind_test_fork > valgrind_test.log 2>&1
    grep "TO DEBUG THIS PROCESS USING GDB: start GDB like this" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb error" 
    valgrind --track-fds=yes ./valgrind_test_fork && valgrind --track-fds=yes ./valgrind_test_fork 2>&1 | grep "FILE DESCRIPTORS"
    CHECK_RESULT $? 0 0 "execute valgrind --track-fds error" 
    valgrind --time-stamp=yes ./valgrind_test_fork > valgrind_test.log 2>&1
    grep -E "[0-99]+:[0-99]+:[0-99]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --time-stamp error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* cachegrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
