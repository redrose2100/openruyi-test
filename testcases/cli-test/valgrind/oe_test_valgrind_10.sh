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
    valgrind --undef-value-errors=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --undef-value-errors error"
    valgrind --track-origins=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --track-origins error" 
    valgrind --partial-loads-ok=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --partial-loads-ok error" 
    valgrind --vgdb-stop-at=none ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-stop-at error" 
    valgrind --unw-stack-scan-thresh=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --unw-stack-scan-thresh error" 
    valgrind --unw-stack-scan-frames=10 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --unw-stack-scan-frames error" 
    valgrind --dsymutil=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --dsymutil error" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
