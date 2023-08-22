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
# @Date      :   2023-08-29
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -g -o valgrind_test ./common/valgrind_test_01.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --tool=callgrind --separate-recs3=test01 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-recs3 error"
    valgrind --tool=callgrind --skip-plt=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --skip-plt error"
    valgrind --tool=callgrind --skip-direct-rec=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --skip-direct-rec error"
    valgrind --tool=callgrind --fn-skip=function_to_skip ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --fn-skip error"
    valgrind --tool=callgrind --cache-sim=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --cache-sim error"
    valgrind --tool=callgrind --branch-sim=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --branch-sim error"
    valgrind --tool=callgrind --simulate-wb=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --simulate-wb error"
    valgrind --tool=callgrind --simulate-hwpref=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --simulate-hwpref error"
    valgrind --tool=callgrind --cacheuse=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --cacheuse error"
    valgrind --tool=callgrind --I1=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --I1 error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* callgrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
