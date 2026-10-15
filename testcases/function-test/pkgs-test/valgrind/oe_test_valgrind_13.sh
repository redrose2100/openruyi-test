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
    valgrind --tool=callgrind --instr-atstart=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --instr-atstart error"
    valgrind --tool=callgrind --collect-atstart=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-atstart error"
    valgrind --tool=callgrind --toggle-collect=test01 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --toggle-collect error"
    valgrind --tool=callgrind --collect-jumps=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-jumps error"
    valgrind --tool=callgrind --collect-bus=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-bus error"
    valgrind --tool=callgrind --separate-threads=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-threads error"
    valgrind --tool=callgrind --separate-callers=2 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-callers error"
    valgrind --tool=callgrind --separate-callers2=test01 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-callers2 error"
    valgrind --tool=callgrind --separate-recs=3 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-recs error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* callgrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
