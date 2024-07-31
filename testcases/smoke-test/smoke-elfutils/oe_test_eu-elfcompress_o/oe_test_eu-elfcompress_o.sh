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
# @Desc      :   eu-elfcompress 选项 -o, --output=FILE
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
    # test -o
    test_size_orig="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    eu-elfcompress -o tmp_main_compress $bin_dir/addr2line_main &> ${test_log}
    CHECK_RESULT $? 0 0
    grep 'NOT compressed' $test_log
    CHECK_RESULT $? 0 0
    test_size_orig1="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_orig1" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0
    test_size_comp="$(du -b tmp_main_compress | awk '{print $1}')"
    test "$test_size_comp" -lt "$test_size_orig"
    CHECK_RESULT $? 0 0 

    eu-elfcompress -t none -o tmp_main_decompress tmp_main_compress &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test_size_comp1="$(du -b tmp_main_compress | awk '{print $1}')"
    test "$test_size_comp1" -eq "$test_size_comp"
    CHECK_RESULT $? 0 0
    test_size_decomp="$(du -b tmp_main_decompress | awk '{print $1}')"
    test "$test_size_decomp" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0

    # test --outout && outputfile already exist
    touch tmp_main_compress1
    test_size_comp_orig="$(du -b tmp_main_compress1 | awk '{print $1}')"
    eu-elfcompress --output=tmp_main_compress1 $bin_dir/addr2line_main &> ${test_log}
    CHECK_RESULT $? 0 0
    grep 'NOT compressed' $test_log
    CHECK_RESULT $? 0 0
    test_size_orig2="$(du -b $bin_dir/addr2line_main | awk '{print $1}')"
    test "$test_size_orig2" -eq "$test_size_orig"
    CHECK_RESULT $? 0 0
    test_size_comp2="$(du -b tmp_main_compress1 | awk '{print $1}')"
    test  "$test_size_comp2" -ne "$test_size_comp_orig"
    CHECK_RESULT $? 0 1
    test "$test_size_comp2" -eq "$test_size_comp"
    CHECK_RESULT $? 0 0

    eu-elfcompress -t none --output=tmp_main_decompress1 tmp_main_compress1 &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    test_size_comp3="$(du -b tmp_main_compress1 | awk '{print $1}')"
    test "$test_size_comp3" -eq "$test_size_comp2"
    CHECK_RESULT $? 0 0
    test_size_decomp1="$(du -b tmp_main_decompress1 | awk '{print $1}')"
    test "$test_size_decomp1" -eq "$test_size_decomp"
    CHECK_RESULT $? 0 0

    # test output dir no space
    dd if=/dev/zero of=tmp_fs bs=1M count=10
    mkfs.ext4 tmp_fs
    mkdir tmp_dir
    mount tmp_fs tmp_dir
    dd if=/dev/zero of=tmp_dir/ddfile bs=1M count=20
    df tmp_dir | grep '100%'
    CHECK_RESULT $? 0 0
    eu-elfcompress -o tmp_dir/tmp_test_nospace $bin_dir/addr2line_main > ${test_log} 2> ${test_log}.err
    CHECK_RESULT $? 0 1
    grep 'NOT compressed' ${test_log}
    CHECK_RESULT $? 0 0
    grep 'cannot write data to file' ${test_log}.err
    CHECK_RESULT $? 0 0
    rm -f tmp_dir/ddfile
    cat ${test_log}     # debug info
    cat ${test_log}.err # debug info

    # test outpu dir readonly
    mount -o ro,remount tmp_dir
    df tmp_dir | grep '100%'
    CHECK_RESULT $? 1 0
    mount | grep "$(pwd)/tmp_dir" | grep '(ro,'
    CHECK_RESULT $? 0 0
    eu-elfcompress -o tmp_dir/tmp_test_readonly $bin_dir/addr2line_main > ${test_log} 2> ${test_log}.err
    CHECK_RESULT $? 0 1
    test "$(cat ${test_log})" = ""
    CHECK_RESULT $? 0 0
    grep 'Read-only file system' ${test_log}.err
    CHECK_RESULT $? 0 0
    umount tmp_dir
    cat ${test_log}     # debug info
    cat ${test_log}.err # debug info
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove elfutils
}

main "$@"
