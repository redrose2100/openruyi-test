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
    valgrind --kernel-variant=bproc,android-no-hw-tls,android-gpu-sgx5xx,android-gpu-adreno3xx ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --kernel-variant error"
    valgrind --merge-recursive-frames=0 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --merge-recursive-frames error"
    valgrind --num-transtab-sectors=10 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --num-transtab-sectors error"
    valgrind --avg-transtab-entry-size=64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --avg-transtab-entry-size error"
    valgrind --aspace-minaddr=0x20000 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --aspace-minaddr error"
    valgrind --valgrind-stacksize=1310720 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --valgrind-stacksize error"
    valgrind --show-emwarns=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-emwarns error"
    valgrind --show-emwarns=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-emwarns error"
    valgrind --require-text-symbol=:*libc.so*:malloc ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --require-text-symbol error"
    valgrind --soname-synonyms=somalloc=NONE ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --soname-synonyms error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
