#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2023-11-24 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run bzip2 testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run bzip2 test."
    pushd ./tmp_test || exit
    chmod +x sample*

    bzip2 -1 <sample1.ref >sample1.rb2
    CHECK_RESULT $? 0 0 "run sample1.ref failed!"
    bzip2 -2 <sample2.ref >sample2.rb2
    CHECK_RESULT $? 0 0 "run sample2.ref failed!"
    bzip2 -3 <sample3.ref >sample3.rb2
    CHECK_RESULT $? 0 0 "run sample3.ref failed!"
    bzip2 -d <sample1.bz2 >sample1.tst
    CHECK_RESULT $? 0 0 "run sample1.bz2 failed!"
    bzip2 -d <sample2.bz2 >sample2.tst
    CHECK_RESULT $? 0 0 "run sample2.bz2 failed!"
    bzip2 -ds <sample3.bz2 >sample3.tst
    CHECK_RESULT $? 0 0 "run sample3.bz2 failed!"

    cmp sample1.bz2 sample1.rb2
    CHECK_RESULT $? 0 0 "run cmp sample1.bz2 sample1.rb2 failed!"
    cmp sample2.bz2 sample2.rb2
    CHECK_RESULT $? 0 0 "run cmp sample2.bz2 sample2.rb2 failed!"
    cmp sample3.bz2 sample3.rb2
    CHECK_RESULT $? 0 0 "run cmp sample3.bz2 sample3.rb2 failed!"
    cmp sample1.tst sample1.ref
    CHECK_RESULT $? 0 0 "run cmp sample1.tst sample1.ref failed!"
    cmp sample2.tst sample2.ref
    CHECK_RESULT $? 0 0 "run cmp sample2.tst sample2.ref failed!"
    cmp sample3.tst sample3.ref
    CHECK_RESULT $? 0 0 "run cmp sample3.tst sample3.ref failed!"
    popd || return
    LOG_INFO "End to run bzip2 test."
}

main "$@"
