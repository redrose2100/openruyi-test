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
# @Date      :   2024/06/06
# @License   :   Mulan PSL v2
# @Desc      :   eu-ar 命令修改项 -a -b -c -C -i -N -o -v 
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    which eu-ar || yum -y install elfutils
    rm -f libtest.a
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-ar -rc libtest.a $bin_dir/main.o $bin_dir/test.o &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    ls -l libtest.a
    CHECK_RESULT $? 0 0
    test "$(eu-ar -t libtest.a)" = "$(printf "%s\n%s\n" main.o test.o)"
    CHECK_RESULT $? 0 0

    eu-ar -ar main.o libtest.a $bin_dir/test.h &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test "$(eu-ar -t libtest.a)" = "$(printf "%s\n%s\n%s\n" main.o test.h test.o)"
    CHECK_RESULT $? 0 0

    eu-ar -br main.o libtest.a $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test "$(eu-ar -t libtest.a)" = "$(printf "%s\n%s\n%s\n%s\n" test_main main.o test.h test.o)"
    CHECK_RESULT $? 0 0

    touch main.o
    eu-ar -xC libtest.a main.o &> $test_log
    CHECK_RESULT $? 1 0
    cat $test_log | grep "eu-ar: cannot rename temporary file to* "
    CHECK_RESULT $? 0 0

    test "$(du -b main.o | awk '{print $1}')" -eq 0
    CHECK_RESULT $? 0 0
    eu-ar -x libtest.a main.o &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test "$(du -b main.o | awk '{print $1}')" -eq "$(du -b $bin_dir/main.o | awk '{print $1}')"
    CHECK_RESULT $? 0 0

    eu-ar -ir main.o libtest.a $bin_dir/test_main1 &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test "$(eu-ar -t libtest.a)" = "$(printf "%s\n%s\n%s\n%s\n%s\n" test_main test_main1 main.o teh test.o)"
    CHECK_RESULT $? 0 0

    #DTS2022121304248 eu-ar -x -N COUNT 获取次数应为第COUNT次
    echo 1 > tmp_testfile
    eu-ar -q libtest.a tmp_testfile
    echo 2 > tmp_testfile
    eu-ar -q libtest.a tmp_testfile
    echo 3 > tmp_testfile
    eu-ar -q libtest.a tmp_testfile
    eu-ar -x -o -N 2 libtest.a tmp_testfile &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test "$(cat tmp_testfile)" = 2
    CHECK_RESULT $? 0 0
    eu-ar -tv libtest.a # debug info
    LOG_INFO "End to run test."
}

function post_test() {
    rm -f main.o libtest.a 
    yum -y remove elfutils
}

main "$@"

