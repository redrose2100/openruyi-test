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
# @Author    :   leijie
# @Contact   :   1836111966@qq.com
# @Date      :   2024-07-31
# @License   :   Mulan PSL v2
# @Desc      :   Command test-pzstd
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL zstd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa | grep zstd
    CHECK_RESULT $? 0 0 "check zstd install"
    dd if=/dev/zero of=bigfile bs=1G count=1
    CHECK_RESULT $? 0 0 "raw file"
    pzstd -V &> tmp_file
    grep "PZSTD version" tmp_file
    CHECK_RESULT $? 0 0 "check pztsd -V" 
    echo teststr > testfile
    /usr/bin/time -f %U pzstd -p1 bigfile &> tmp_file
    time_1=$(awk 'NR==2 {print $1}' tmp_file)
    rm -rf bigfile.zst
    /usr/bin/time -f %U pzstd -p4 bigfile &> tmp_file
    time_4=$(awk 'NR==2 {print $1}' tmp_file)
    # 受环境影响，压缩值相差0.1属于正常现象,判断条件改为差值形式
    val=$(echo "${time_1}" - 0.1 | bc)
    python -c "print(${val} < ${time_4})" | grep "True"
    CHECK_RESULT $? 0 0 "check pzstd -p time"
    python -c "print(${val} < 1)" | grep "True"
    CHECK_RESULT $? 0 0 "check pzstd -p time"

    /usr/bin/time -f %U pzstd -3 -f bigfile &> tmp_file
    t_level_3=$(awk 'NR==2 {print $1}' tmp_file)
    /usr/bin/time -f %U pzstd -5 -f bigfile &> tmp_file
    t_level_5=$(awk 'NR==2 {print $1}' tmp_file)
    python -c "print(${t_level_3} < ${t_level_5})" | grep "True"
    CHECK_RESULT $? 0 0 "check pzstd level"
    python -c "print(${t_level_3} < 1)" | grep "True"
    CHECK_RESULT $? 0 0 "check pzstd level"

    pzstd testfile
    CHECK_RESULT $? 0 0 "check pzstd file"
    echo y | pzstd -d testfile.zst
    CHECK_RESULT $? 0 0 "check pzstd -d zst"
    pzstd -f testfile -o tmp_out
    CHECK_RESULT $? 0 0 "check pzstd -f file -o output"
    test -f tmp_out
    CHECK_RESULT $? 0 0 "check pzstd -f file -o output"
    pzstd -f --ultra -20 -k testfile -o tmp_out
    CHECK_RESULT $? 0 0 "check pzstd --ultra" 
    pzstd -c -f --rm -o tmp_out testfile
    CHECK_RESULT $? 0 0 "check pzstd --rm" 
    test -f testfile
    CHECK_RESULT $? 0 1 "check pzstd --rm" 
    pzstd -t tmp_out --no-check &> tmp_file
    CHECK_RESULT $? 0 0 "check pzstd -t" 
    grep tmp_out tmp_file
    CHECK_RESULT $? 0 0 "check pzstd -t"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf testfile* tmp* bigfile*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"