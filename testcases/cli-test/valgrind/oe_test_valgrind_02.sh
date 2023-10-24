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
    g++ -g -o valgrind_test ./common/valgrind_test_02.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --leak-check=full --show-reachable=no ./valgrind_test > valgrind_test.log 2>&1
    grep "eachable blocks (those to which a pointer was found) are not shown" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-reachable error" 
    valgrind --leak-check=full --show-possibly-lost=no  ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-possibly-lost error" 
    valgrind --xtree-leak=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "xtree leak report" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-leak error" 
    valgrind --xtree-leak=yes --xtree-leak-file=valgrind_test_report.txt ./valgrind_test 
    grep "# callgrind format" valgrind_test_report.txt
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-leak-file error" 
    valgrind --expensive-definedness-checks=no ./valgrind_test 
    CHECK_RESULT $? 0 0 "execute valgrind --expensive-definedness-checks error" 
    valgrind --leak-check=full --keep-stacktraces=none ./valgrind_test 2>&1 | grep "at 0x0: ???"
    CHECK_RESULT $? 0 0 "execute valgrind --keep-stacktraces error" 
    valgrind --leak-check=full --freelist-vol=100 ./valgrind_test > valgrind_test.log 2>&1
    grep "freelist-vol value 100" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --freelist-vol error" 
    valgrind --leak-check=full --freelist-big-blocks=30000000 ./valgrind_test > valgrind_test.log 2>&1
    grep "reelist-big-blocks value 30000000" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --freelist-vol error" 
    valgrind --leak-check=full --workaround-gcc296-bugs=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Warning: --workaround-gcc296-bugs=yes is deprecated." valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --workaround-gcc296-bugs error" 
    valgrind  --show-mismatched-frees=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Mismatched free() \/ delete \/ delete \[\]" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --show-mismatched-frees error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* xtleak.kcg.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
