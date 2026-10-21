#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.10.16
# @License   :   Mulan PSL v2
# @Desc      :   unzstd formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment." 
    echo "This is a testfile for unzstd" > testfile_unzstd
    zstd testfile_unzstd
    rm -f testfile_unzstd
    cp testfile_unzstd.zst testfile_backup.zst
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    unzstd testfile_unzstd.zst
    CHECK_RESULT $? 0 0 "unzstd error"
    res1=$(cat testfile_unzstd)
    [ "$res1" == "This is a testfile for unzstd" ]
    CHECK_RESULT $? 0 0 "unzstd error"
    unzstd -k testfile_backup.zst -q
    CHECK_RESULT $? 0 0 "unzstd -k error"
    ls testfile_backup.zst testfile_backup &> /dev/null
    CHECK_RESULT $? 0 0 "unzstd -k keep error"
    echo "old" > testfile_unzstd
    unzstd -f testfile_unzstd.zst -q
    CHECK_RESULT $? 0 0 "unzstd -f error"
    grep -q "This is a testfile for unzstd" testfile_unzstd
    CHECK_RESULT $? 0 0 "unzstd -f overwrite error"
    mkdir -p output_dir
    unzstd -o output_dir/testfile.txt testfile_unzstd.zst -q
    CHECK_RESULT $? 0 0 "unzstd -o error"
    ls output_dir/testfile.txt &> /dev/null
    CHECK_RESULT $? 0 0 "unzstd -o output file error"
    grep -q "This is a testfile for unzstd" output_dir/testfile.txt
    CHECK_RESULT $? 0 0 "unzstd -o content error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_unzstd.zst testfile_unzstd
    rm -f testfile_backup testfile_backup.zst
    rm -rf output_dir
    LOG_INFO "End to restore the test environment."
}

main "$@"
