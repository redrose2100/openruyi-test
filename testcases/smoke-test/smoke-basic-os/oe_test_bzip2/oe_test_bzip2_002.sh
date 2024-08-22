#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunshang
# @Contact   :   sunshang <sunshang4@h-partners.com>
# @Date      :   2024-07-31
# @License   :   Mulan PSL v2
# @Desc      :   bzip2 check options
# ############################################
source  "${OET_PATH}"/libs/locallibs/common_lib.sh
testfile=file_$RANDOM
set +e

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which bzip2 || yum install -y bzip2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    dd if=/dev/zero of=$testfile bs=100K count=90
    bzip2 -z "${testfile}"
    CHECK_RESULT  $? 0 0 "test faild with option -z"
    bzip2 -d "${testfile}".bz2
    CHECK_RESULT  $? 0 0 "test faild with option -d"
    bzip2 -zk "${testfile}"
    CHECK_RESULT  $? 0 0 "test faild with option -zk"
    bzip2 -zkf "${testfile}"
    CHECK_RESULT  $? 0 0 "test faild with option -zkf"
    bzip2 -df "${testfile}".bz2
    CHECK_RESULT  $? 0 0 "test faild with option -df"
    bzip2 -zkvf "${testfile}"
    CHECK_RESULT  $? 0 0 "test faild with option -zkvf"
    bzip2 -dkvf "${testfile}".bz2
    CHECK_RESULT  $? 0 0 "test faild with option -dkvf"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y bzip2" | head -n1 | awk '{print $1}')
    [ -z "$id" ] || yum history undo -y "$id"
    rm -fr "${testfile}"*
    LOG_INFO "End to clean the test environment."
}

main "$@"
