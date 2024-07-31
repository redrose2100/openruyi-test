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
# @Desc      :   eu-strings 输出选择选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    which eu-strings || yum -y install elfutils
}

function run_test() {
    LOG_INFO "Start to run test."
    # no option
    eu-strings $bin_dir/test_main &> ${test_log}
    CHECK_RESULT $? 0 0
    grep "test" ${test_log}
    CHECK_RESULT $? 0 0
    # test -a/--all
    eu-strings -a $bin_dir/test_main &> ${test_log}_a
    CHECK_RESULT $? 0 0
    diff ${test_log} ${test_log}_a | grep '^<'
    CHECK_RESULT $? 1 0
    diff ${test_log} ${test_log}_a | grep '^> test.c'
    CHECK_RESULT $? 0 0
    diff ${test_log} ${test_log}_a | grep '> .text'
    CHECK_RESULT $? 0 0
    eu-strings --all $bin_dir/test_main &> ${test_log}_all
    CHECK_RESULT $? 0 0
    diff ${test_log}_a ${test_log}_all
    CHECK_RESULT $? 0 0
    # test -f/--print-file-name
    eu-strings -f $bin_dir/test_main &> ${test_log}_f
    CHECK_RESULT $? 0 0
    grep "test_main: test" ${test_log}_f
    CHECK_RESULT $? 0 0
    eu-strings --print-file-name $bin_dir/test_main &> ${test_log}_file
    CHECK_RESULT $? 0 0
    diff ${test_log}_f ${test_log}_file
    CHECK_RESULT $? 0 0
    # test -n/--bytes=
    eu-strings -n 10 $bin_dir/test_main &> ${test_log}_n
    CHECK_RESULT $? 0 0
    while read line; do
        test "$(echo "$line" | wc -c)" -ge "10"
        CHECK_RESULT $? 0 0
    done < ${test_log}_n
    diff ${test_log}_n ${test_log} | grep '^<'
    CHECK_RESULT $? 1 0
    eu-strings --bytes=10 $bin_dir/test_main &> ${test_log}_bytes
    CHECK_RESULT $? 0 0
    diff ${test_log}_n ${test_log}_bytes
    CHECK_RESULT $? 0 0
    # test -t/--radix=
    eu-strings -t d $bin_dir/test.h &> ${test_log}_td
    CHECK_RESULT $? 0 0
    grep "106 int test(void);" ${test_log}_td
    CHECK_RESULT $? 0 0
    eu-strings --radix=o $bin_dir/test.h &> ${test_log}_to
    CHECK_RESULT $? 0 0
    grep "$(printf "%o" 106) int test(void);" ${test_log}_to
    CHECK_RESULT $? 0 0
    eu-strings --radix=x $bin_dir/test.h &> ${test_log}_tx
    CHECK_RESULT $? 0 0
    grep "$(printf "%x" 106) int test(void);" ${test_log}_tx
    CHECK_RESULT $? 0 0
    # test -e/--encoding=
    eu-strings -e s $bin_dir/test_main &> ${test_log}_es
    CHECK_RESULT $? 0 0
    diff ${test_log}_es ${test_log}
    CHECK_RESULT $? 0 0
    eu-strings --encoding=S $bin_dir/test_main &> ${test_log}_eS
    CHECK_RESULT $? 0 0
    diff ${test_log}_eS ${test_log}
    CHECK_RESULT $? 0 0
    eu-strings -e b $bin_dir/test_main &> ${test_log}_eb
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_eb)" = ""
    CHECK_RESULT $? 0 0
    eu-strings -e l $bin_dir/test_main &> ${test_log}_el
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_el)" = ""
    CHECK_RESULT $? 0 0
    eu-strings -e B $bin_dir/test_main &> ${test_log}_eB
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_eB)" = ""
    CHECK_RESULT $? 0 0
    eu-strings -e L $bin_dir/test_main &> ${test_log}_eL
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_eL)" = ""
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    cat ${test_log} # debug info
    yum -y remove elfutils
}

main "$@"

