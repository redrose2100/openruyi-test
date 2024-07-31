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
# @Desc      :   eu-elfcmp 控制选项 -l -q --ignore-build-id
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
source ./package_lib.sh
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    yum -y install elfutils eu-elfcmp
}

function run_test() {
    LOG_INFO "Start to run test."
    cp $bin_dir/test_main tmp_test_main
    eu-elfcmp $bin_dir/test_main tmp_test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfcmp -q $bin_dir/test_main tmp_test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfcmp $bin_dir/test_main $bin_dir/test_main1 &> $test_log
    CHECK_RESULT $? 1 0
    test "$(cat $test_log)" = "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: build  ID content"
    CHECK_RESULT $? 0 0
    eu-elfcmp -q $bin_dir/test_main $bin_dir/test_main1 &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfcmp --quiet $bin_dir/test_main $bin_dir/test_main1 &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 0

    eu-elfcmp -l $bin_dir/test_main $bin_dir/test_main1 &> $test_log
    CHECK_RESULT $? 1 0
    grep -F "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: build ID content" $test_log
    CHECK_RESULT $? 0 0
    grep "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: section \[[0-9]\+\] '.rodata'      header" $test_log
    CHECK_RESULT $? 0 0
    grep "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: section \[[0-9]\+\] '.rodata'      content" $test_log
    CHECK_RESULT $? 0 0
    eu-elfcmp --verbose $bin_dir/test_main $bin_dir/test_main1 &> ${test_log}_1
    CHECK_RESULT $? 1 0
    diff $test_log ${test_log}_1
    CHECK_RESULT $? 0 0

    eu-elfcmp --ignore-build-id $bin_dir/test_main $bin_dir/test_main1 &> ${test_log}
    CHECK_RESULT $? 1 0
    grep -F "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: build ID content" $test_log
    CHECK_RESULT $? 1 0
    grep "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: section \[[0-9]\+\] '.rodata'      header" $test_log
    CHECK_RESULT $? 0 0
    grep "eu-elfcmp: $bin_dir/test_main $bin_dir/test_main1 differ: section \[[0-9]\+\] '.rodata'      content" $test_log
    CHECK_RESULT $? 1 0
    LOG_INFO "End to run test."
}

function post_test() {
    rm -rf $test_log
    yum -y remove elfutils eu-elfcmp
}

main "$@"

