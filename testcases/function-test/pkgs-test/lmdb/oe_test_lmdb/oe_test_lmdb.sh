#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-02-07
# @License   :   Mulan PSL v2
# @Desc      :   lmdb basic function
# ############################################
# shellcheck disable=SC2002

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lmdb unzip"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkdir lmdb && cd lmdb || exit
    cp ../students.zip ./ && unzip students.zip
    find students | grep -E 'data.mdb|lock.mdb'
    CHECK_RESULT $? 0 0 "Decompression failed"
    mdb_stat students/
    CHECK_RESULT $? 0 0 "Failed to view LMDB data"
    mkdir students_copy
    mdb_copy -c students students_copy
    mdb_stat students_copy
    ent_copy=$(mdb_stat students_copy | grep Entries|awk -F: '{print $2}')
    CHECK_RESULT $? 0 0 "Failed to view LMDB data"
    rm -fr test
    mdb_dump students -f test
    result=$(cat test| wc -l)
    CHECK_RESULT "$result" 0 1 "Failed to export LMDB data"
    mdb_load -f test -N -T students
    ent=$(mdb_stat students | grep 'Entries' |awk -F: '{print $2}')
    entries=$((ent - ent_copy))
    [ ${entries} -gt 0 ]
    check_result $? 0 "Failed to view LMDB data"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf lmdb students_copy test
    LOG_INFO "End to restore the test environment."
}

main "$@"