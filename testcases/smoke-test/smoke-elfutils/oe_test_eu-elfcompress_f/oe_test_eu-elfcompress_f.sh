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
# @Desc      :   eu-elfcompress 选项 -f, --force
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
    eu-elfcompress -f -v $bin_dir/addr2line_main &> ${test_log}_compress
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_compress
    CHECK_RESULT $? 0 0
    force_compress_list="\.debug_aranges \.debug_line"
    for test_section in $force_compress_list; do
        grep "$test_section compressed" ${test_log}_compress
        CHECK_RESULT $? 0 0
        size_before="$(grep "$test_section " ${test_log}_compress | awk -F'(' '{print $2}' | awk '{print $1}')"
        size_after="$(grep "$test_section " ${test_log}_compress | awk -F'(' '{print $2}' | awk '{print $3}')"
        if version_compare "${ETS_VERSION}" "<" "V200R011C00" && [ "$test_section" = "\.debug_line" ]; then
            test "$size_before" -gt "$size_after"
            CHECK_RESULT $? 0 0
        else
            test "$size_before" -lt "$size_after"
            CHECK_RESULT $? 0 0
        fi
    done
    compress_list="\.debug_info \.debug_abbrev \.debug_str"
    for test_section in $compress_list; do
        grep "$test_section compressed" ${test_log}_compress
        CHECK_RESULT $? 0 0
        size_before="$(grep "$test_section " ${test_log}_compress | awk -F'(' '{print $2}' | awk '{print $1}')"
        size_after="$(grep "$test_section " ${test_log}_compress | awk -F'(' '{print $2}' | awk '{print $3}')"
        test "$size_before" -gt "$size_after"
        CHECK_RESULT $? 0 0
    done
    test_size_comp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_comp_1" -lt "$test_size_orig"
    CHECK_RESULT $? 0 0

    eu-elfcompress --force -t none -v $bin_dir/addr2line_main &> ${test_log}_decompress
    CHECK_RESULT $? 0 0
    grep "processing: $bin_dir/addr2line_main" ${test_log}_decompress
    CHECK_RESULT $? 0 0
    for test_section in $force_compress_list; do
        grep "$test_section decompressed" ${test_log}_decompress
        CHECK_RESULT $? 0 0
        size_before="$(grep "$test_section " ${test_log}_decompress | awk -F'(' '{print $2}' | awk '{print $1}')"
        size_after="$(grep "$test_section " ${test_log}_decompress | awk -F'(' '{print $2}' | awk '{print $3}')"
        if version_compare "${ETS_VERSION}" "<" "V200R011C00" && [ "$test_section" = "\.debug_line" ]; then
            test "$size_before" -lt "$size_after"
            CHECK_RESULT $? 0 0
        else
            test "$size_before" -gt "$size_after"
            CHECK_RESULT $? 0 0
        fi
    done
    for test_section in $compress_list; do
        grep "$test_section decompressed" ${test_log}_decompress
        CHECK_RESULT $? 0 0
        size_before="$(grep "$test_section " ${test_log}_decompress | awk -F'(' '{print $2}' | awk '{print $1}')"
        size_after="$(grep "$test_section " ${test_log}_decompress | awk -F'(' '{print $2}' | awk '{print $3}')"
        test "$size_before" -lt "$size_after"
        CHECK_RESULT $? 0 0
    done
    test_size_decomp_1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_decomp_1" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove elfutils
}

main "$@"
