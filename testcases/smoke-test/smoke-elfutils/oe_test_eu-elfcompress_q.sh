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
# @Desc      :   eu-elfclassify 输入选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    which eu-elfcompress || yum -y install elfutils
}

function run_test() {
    LOG_INFO "Start to run test."
    test_size_orig="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    eu-elfcompress -q $bin_dir/addr2line_main &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test_size_comp="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp" -lt "$test_size_orig"
    CHECK_RESULT $? 0 0
    eu-elfcompress -q -t none $bin_dir/addr2line_main &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test_size_decomp="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress --quiet $bin_dir/addr2line_main &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test_size_comp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_1" -eq "$test_size_comp"
    CHECK_RESULT $? 0 0
    eu-elfcompress --quiet -t none $bin_dir/addr2line_main &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test_size_decomp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_1" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0

    test -f notexist
    CHECK_RESULT $? 0 1
    eu-elfcompress -q notexist > ${test_log} 2> ${test_log}.err
    CHECK_RESULT $? 0 1
    test "$(cat ${test_log})" = ""
    CHECK_RESULT $? 0 0
    grep "No such file or directory" ${test_log}.err
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove elfutils
}


main "$@"
