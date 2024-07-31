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
# @Date      :   2024/06/04
# @License   :   Mulan PSL v2
# @Desc      :   eu-addr2line 输出格式选项 -a -A -f --pretty-print -F -s -S -x
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh > /dev/null
source ./package_lib.sh
set +e
test_log=tmp_test.log
bin_dir=./usr
src_repo=/etc/yum.repos.d/tmp_src.repo

function pre_test() {
    yum -y install elfutils eu-addr2line
}

function run_test() {
    LOG_INFO "Start to run test."
    main_addr=$(grep -w 'main' $bin_dir/addr2line_main.map | awk '{print $1}')
    testfun_addr=$(grep -w 'TestFun1' $bin_dir/addr2line_main.map | awk '{print $1}')
    eu-addr2line "$main_addr" "$testfun_addr" -e $bin_dir/addr2line_main -a -f --pretty-print &>         ${test_log}_a
    CHECK_RESULT $? 0 0
    test "$(wc -l ${test_log}_a | awk '{print $1}')" -eq 2
    CHECK_RESULT $? 0 0
    main_line_num=$(grep -nr -A3 'main(' ../usr/addr2line_main.c | grep '{' | awk -F':|-' '{print $1}')
    testfun_line_num=$(grep -nr -A3 'TestFun1(' ../usr/addr2line_main.c | grep '{' | awk -F':|-' '{print $1}')
    grep "$main_addr: main at .*/package_test/elfutils/usr/addr2line_main.c:$main_line_num" ${test_log}_a
    CHECK_RESULT $? 0 0
    grep "$testfun_addr: TestFun1 at .*/package_test/elfutils/usr/addr2line_main.c:$test_funline_num"    ${test_log}_a
    CHECK_RESULT $? 0 0
    eu-addr2line "$main_addr" "$testfun_addr" -e $bin_dir/addr2line_main --addresses --functions --      pretty-print &> ${test_log}_a1
    test "$(cat ${test_log}_a)" = "$(cat ${test_log}_a1)"
    CHECK_RESULT $? 0 0

    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main -F &> ${test_log}_F
    CHECK_RESULT $? 0 0
    test "$(wc -l ${test_log}_F | awk '{print $1}')" -eq 1
    CHECK_RESULT $? 0 0
    if version_compare "$(eu-addr2line --version | grep eu-addr2line | awk '{print $NF}')" ">=" "0.185"; then
        grep "package_test/elfutils/usr/addr2line_main.c:${main_line_num}:1 (is_stmt)" ${test_log}_F
        CHECK_RESULT $? 0 0
    else
        grep "package_test/elfutils/usr/addr2line_main.c:$main_line_num (is_stmt)" ${test_log}_F
        CHECK_RESULT $? 0 0
    fi
    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main --flags &> ${test_log}_F1
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_F)" = "$(cat ${test_log}_F1)"
    CHECK_RESULT $? 0 0

    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main -s &> ${test_log}_s
    CHECK_RESULT $? 0 0
    if version_compare "$(eu-addr2line --version | grep eu-addr2line | awk '{print $NF}')" ">=" "0.185"; then
        test "addr2line_main.c:${main_line_num}:1" = "$(cat ${test_log}_s)"
        CHECK_RESULT $? 0 0
    else
        test "addr2line_main.c:$main_line_num" = "$(cat ${test_log}_s)"
        CHECK_RESULT $? 0 0
    fi
    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main --basenames &> ${test_log}_s1
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_s)" = "$(cat ${test_log}_s1)"
    CHECK_RESULT $? 0 0

    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main -S &> ${test_log}_S
    CHECK_RESULT $? 0 0
    test "$(wc -l ${test_log}_S | awk '{print $1}')" -eq 2
    CHECK_RESULT $? 0 0
    grep '^main$' ${test_log}_S
    CHECK_RESULT $? 0 0
    grep "package_test/elfutils/usr/addr2line_main.c:$main_line_num" ${test_log}_S
    CHECK_RESULT $? 0 0
    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main --symbols &> ${test_log}_S1
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_S)" = "$(cat ${test_log}_S1)"
    CHECK_RESULT $? 0 0

    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main -x &> ${test_log}_x
    CHECK_RESULT $? 0 0
    test "$(wc -l ${test_log}_x | awk '{print $1}')" -eq 2
    CHECK_RESULT $? 0 0
    grep '^main (.text)$' ${test_log}_x
    CHECK_RESULT $? 0 0
    grep "package_test/elfutils/usr/addr2line_main.c:$main_line_num" ${test_log}_x
    CHECK_RESULT $? 0 0
    eu-addr2line "$main_addr" -e $bin_dir/addr2line_main --symbols-sections &> ${test_log}_x1
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_x)" = "$(cat ${test_log}_x1)"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    rm -f ${test_log}*
    yum -y remove elfutils eu-addr2line

main "$@"
