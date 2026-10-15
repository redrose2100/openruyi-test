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
cat > valgrind_test_suppressions.supp << EOF
{
   Mismatched free() / delete / delete []
   Memcheck:Leak
   fun:*
}
EOF
    g++ -g -o valgrind_test ./common/valgrind_test_05.cpp
    g++ -g -o valgrind_test_fork ./common/valgrind_test_04.cpp
    objcopy --only-keep-debug valgrind_test_fork valgrind_test_fork.debug
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --sigill-diagnostics=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --sigill-diagnostics error"
    valgrind --show-below-main=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-below-main error"
    valgrind --fullpath-after= ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --fullpath-after error"
    valgrind --extra-debuginfo-path=valgrind_test_fork.debug ./valgrind_test_fork
    CHECK_RESULT $? 0 0 "execute valgrind --extra-debuginfo-path error"
    valgrind --allow-mismatched-debuginfo=yes ./valgrind_test_fork
    CHECK_RESULT $? 0 0 "execute valgrind --allow-mismatched-debuginfo error"
    valgrind --suppressions=valgrind_test_suppressions.supp ./valgrind_test 
    CHECK_RESULT $? 0 0 "execute valgrind --suppressions error"
    valgrind --gen-suppressions=all ./valgrind_test 
    CHECK_RESULT $? 0 0 "execute valgrind --gen-suppressions error"
    valgrind --gen-suppressions=yes --input-fd=3 ./valgrind_test 
    CHECK_RESULT $? 0 0 "execute valgrind --input-fd error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* vgcore*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
