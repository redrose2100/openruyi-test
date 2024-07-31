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
# @Desc      :   eu-elfcompress 选项 -t, --type=TYPE
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
    file $bin_dir/addr2line_main | grep 'with debug_info'
    CHECK_RESULT $? 0 0
    test_size_orig="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    eu-elfcompress -t zlib -v $bin_dir/addr2line_main &> ${test_log}_compress
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_compress
    CHECK_RESULT $? 0 0
    grep -E ' .debug_[a-z]* NOT compressed' ${test_log}_compress
    CHECK_RESULT $? 0 0
    grep -E ' .debug_[a-z]* compressed \(' ${test_log}_compress
    CHECK_RESULT $? 0 0
    test_size_comp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_1" -lt "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress -t none -v $bin_dir/addr2line_main &> ${test_log}_decompress
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_decompress
    CHECK_RESULT $? 0 0
    grep -E '.debug_[a-z]* already decompressed' ${test_log}_decompress
    CHECK_RESULT $? 0 0
    grep -E '.debug_[a-z]* decompressed \(' ${test_log}_decompress
    CHECK_RESULT $? 0 0
    test_size_decomp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_1" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress --type=zlib-gnu -v $bin_dir/addr2line_main &> ${test_log}_compress1
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_compress1
    CHECK_RESULT $? 0 0

    if version_compare "${ETS_VERSION}" ">=" "V200R011"; then
        grep -E ' .debug_[a-z]* NOT compressed' ${test_log}_compress1
        CHECK_RESULT $? 0 0
    fi

    grep -E ' .debug_([a-z]*) compressed -> .zdebug_\1 \(' ${test_log}_compress1
    CHECK_RESULT $? 0 0
    test_size_comp_2="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_2" -lt "$test_size_comp_1"
    CHECK_RESULT $? 0 0

    eu-elfcompress --type=none -v $bin_dir/addr2line_main &> ${test_log}_decompress1
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_decompress1
    CHECK_RESULT $? 0 0
    if version_compare "${ETS_VERSION}" ">=" "V200R011"; then
        grep -E '.debug_[a-z]* already decompressed' ${test_log}_decompress1
        CHECK_RESULT $? 0 0
    fi
    grep -E ' .zdebug_([a-z]*) decompressed -> .debug_\1 \(' ${test_log}_decompress1
    CHECK_RESULT $? 0 0
    test_size_decomp_2="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_2" -eq "$test_size_orig"
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



