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
# @Desc      :   eu-elfcompress 默认执行
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=../usr

function pre_test() {
    which eu-elfcompress || yum -y install elfutils
}

function run_test() {
    LOG_INFO "Start to run test."
    # test compress file with .debug info
    file $bin_dir/addr2line_main | grep 'with debug_info'
    CHECK_RESULT $? 0 0
    test_size_orig="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    eu-elfcompress $bin_dir/addr2line_main &> ${test_log}_compress
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_compress
    CHECK_RESULT $? 1 0
    grep -E ' .debug_[a-z]* NOT compressed' ${test_log}_compress
    CHECK_RESULT $? 0 0
    grep -E ' .debug_[a-z]* compressed \(' ${test_log}_compress
    CHECK_RESULT $? 1 0
    test_size_comp="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp" -lt "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress $bin_dir/addr2line_main &> ${test_log}_compress1
    CHECK_RESULT $? 0 0
    diff ${test_log}_compress ${test_log}_compress1
    CHECK_RESULT $? 0 0
    test_size_comp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_1" -eq "$test_size_comp"
    CHECK_RESULT $? 0 0
    # test decompress file with .debug info
    eu-elfcompress -t none $bin_dir/addr2line_main &> ${test_log}_decompress
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_decompress)" = ""
    CHECK_RESULT $? 0 0
    test_size_decomp="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress $bin_dir/addr2line_main &> ${test_log}_compress1
    CHECK_RESULT $? 0 0
    diff ${test_log}_compress ${test_log}_compress1
    CHECK_RESULT $? 0 0
    test_size_comp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_1" -eq "$test_size_comp"
    CHECK_RESULT $? 0 0
    # test decompress file with .debug info
    eu-elfcompress -t none $bin_dir/addr2line_main &> ${test_log}_decompress
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_decompress)" = ""
    CHECK_RESULT $? 0 0
    test_size_decomp="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress -t none $bin_dir/addr2line_main &> ${test_log}_decompress1
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_decompress1)" = ""
    CHECK_RESULT $? 0 0
    test_size_decomp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_1" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0
    # test compress file without .debug info
    file $bin_dir/test_main | grep 'with debug_info'
    CHECK_RESULT $? 1 0
    test_size_orig="$(du -b $bin_dir/test_main | awk '{print $1}')"
    eu-elfcompress $bin_dir/test_main &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log})" = ""
    CHECK_RESULT $? 0 0
    test_size_orig1="$(du -b $bin_dir/test_main | awk '{print $1}')"
    test "$test_size_orig1" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0
    # test decompress file without .debug info
    eu-elfcompress -t none $bin_dir/test_main &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log})" = ""
    CHECK_RESULT $? 0 0
    test_size_orig2="$(du -b $bin_dir/test_main | awk '{print $1}')"
    test "$test_size_orig2" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    cat ${test_log}_compress    # debug info
    cat ${test_log}_decompress  # debug info
    cat ${test_log}_compress1   # debug info
    cat ${test_log}_decompress1 # debug info
    yum -y remove elfutils
}

main "$@"
