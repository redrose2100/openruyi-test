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
    g++ -g -o valgrind_test ./common/valgrind_test_05.cpp
    g++ -g -o valgrind_test_largestack ./common/valgrind_test_06.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind  --max-stackframe=1 ./valgrind_test > valgrind_test.log 2>&1
    grep "Invalid read of size 8" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --max-stackframe error"
    valgrind --main-stacksize=1048576 ./valgrind_test_largestack > valgrind_test.log 2>&1
    grep "Stack allocated." valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --main-stacksize error"
    valgrind --max-threads=1 ./valgrind_test > valgrind_test.log 2>&1
    grep "Use --max-threads=INT to specify a larger number of threads" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --max-threads error"
    valgrind --alignment=32 ./valgrind_test_largestack
    CHECK_RESULT $? 0 0 "execute valgrind --alignment error"
    valgrind --redzone-size=0 ./valgrind_test_largestack
    CHECK_RESULT $? 0 0 "execute valgrind --redzone-size error"  
    valgrind --xtree-memory=allocs ./valgrind_test_largestack
    grep "creator: xtree-1"  xtmemory.kcg.*
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-memory  error" 
    valgrind --xtree-memory=allocs --xtree-memory-file=valgrind_test_xtmemory.log ./valgrind_test_largestack
    grep "creator: xtree-1"  valgrind_test_xtmemory.log
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-memory-file  error" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* vgcore* xtmemory.kcg.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
