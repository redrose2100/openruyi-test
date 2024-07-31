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
# @Desc      :   eu-elfcompress 选项 -v, --verbose
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
    file $bin_dir/addr2line_main | grep 'with debug_info'
    CHECK_RESULT $? 0 0
    test_size_orig="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    eu-elfcompress -v $bin_dir/addr2line_main &> ${test_log}_compress1
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_compress1
    CHECK_RESULT $? 0 0
    not_compress_list="\.debug_aranges \.debug_line"
    for test_section in $not_compress_list; do
        if version_compare "${ETS_VERSION}" "<" "V200R011C00" && [ "$test_section" = "\.debug_aranges" ]; then
            grep "$test_section NOT compressed" ${test_log}_compress1
            CHECK_RESULT $? 0 0
        fi
    done
    compress_list="\.debug_info \.debug_abbrev \.debug_str"
    for test_section in $compress_list; do
        grep "$test_section compressed" ${test_log}_compress1
        CHECK_RESULT $? 0 0
    done
    test_size_comp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_1" -lt "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress -t none -v $bin_dir/addr2line_main &> ${test_log}_decompress1
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_decompress1
    CHECK_RESULT $? 0 0
    for test_section in $not_compress_list; do
        if version_compare "${ETS_VERSION}" "<" "V200R011C00" && [ "$test_section" = "\.debug_aranges" ]; then
            grep "$test_section already decompressed" ${test_log}_decompress1
            CHECK_RESULT $? 0 0
        fi
    done

    for test_section in $compress_list; do
        grep "$test_section decompressed" ${test_log}_decompress1
        CHECK_RESULT $? 0 0
    done
    test_size_decomp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_1" -eq "$test_size_orig"
    CHECH_RESULT $? 0 0

    eu-elfcompress --verbose $bin_dir/addr2line_main &> ${test_log}_compress2
    CHECK_RESULT $? 0 0
    diff ${test_log}_compress1 ${test_log}_compress2
    CHECK_RESULT $? 0 0
    test_size_comp_2="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_2" -eq "$test_size_comp_1"
    CHECH_RESULT $? 0 0

    eu-elfcompress -t none --verbose $bin_dir/addr2line_main &> ${test_log}_decompress2
    CHECK_RESULT $? 0 0
    diff ${test_log}_decompress1 ${test_log}_decompress2
    CHECK_RESULT $? 0 0
    test_size_decomp_2="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_2" -eq "$test_size_orig"
    CHECH_RESULT $? 0 0

    file $bin_dir/test_main | grep 'with debug_info'
    CHECK_RESULT $? 1 0
    test_size_nochange_orig="$(du -b $bin_dir/test_main | awk '{print $1}')"
    eu-elfcompress -v $bin_dir/test_main &> ${test_log}_1
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/test_main" ${test_log}_1
    CHECK_RESULT $? 0 0
    grep "Nothing to do." ${test_log}_1
    CHECK_RESULT $? 0 0
    test_size_nochange_1="$(du -b $bin_dir/test_main | awk '{print $1}')"
    test "$test_size_nochange_orig" -eq "$test_size_nochange_1"
    CHECH_RESULT $? 0 0

    eu-elfcompress -t none --verbose $bin_dir/test_main &> ${test_log}_2
    CHECK_RESULT $? 0 0
    diff ${test_log}_1 ${test_log}_2
    CHECK_RESULT $? 0 0
    test_size_nochange_2="$(du -b $bin_dir/test_main | awk '{print $1}')"
    test "$test_size_nochange_orig" -eq "$test_size_nochange_2"
    CHECH_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove elfutils
}

main "$@"



