#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/06/05
# @License   :   Mulan PSL v2
# @Desc      :   eu-ar 命令
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
test_log=tmp_test.log
bin_dir=../usr

function pre_test() {
    yum -y install elfutils eu-ar
    rm -f libtest.a
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-ar -r libtest.a $bin_dir/main.o &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "eu-ar: creating libtest.a"
    CHECK_RESULT $? 0 0

    eu-ar -t libtest.a &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "main.o"
    CHECK_RESULT $? 0 0

    eu-ar -q libtest.a $bin_dir/test.o &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    eu-ar -t libtest.a &> $test_log
    test "$(cat $test_log)" = "$(printf "%s\n%s\n" main.o test.o)"
    CHECK_RESULT $? 0 0

    eu-ar -m libtest.a main.o &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    eu-ar -t libtest.a &> $test_log
    test "$(cat $test_log)" = "$(printf "%s\n%s\n" test.o main.o)"
    CHECK_RESULT $? 0 0

    eu-ar -q libtest.a $bin_dir/test.h
    eu-ar -p libtest.a test.h &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "$(cat $bin_dir/test.h)"
    CHECK_RESULT $? 0 0

    [ ! -f test.h ]
    CHECK_RESULT $? 0 0
    eu-ar -x libtest.a test.h &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    diff test.h $bin_dir/test.h
    CHECK_RESULT $? 0 0

    eu-ar -t libtest.a &> $test_log
    test "$(cat $test_log)" = "$(printf "%s\n%s\n%s\n" test.o main.o test.h)"
    CHECK_RESULT $? 0 0
    eu-ar -d libtest.a test.h &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    eu-ar -t libtest.a &> $test_log
    test "$(cat $test_log)" = "$(printf "%s\n%s\n" test.o main.o)"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    rm -f $test_log test.h libtest.a
    yum -y remove elfutils eu-ar
}

main "$@"
