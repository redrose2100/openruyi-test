#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test pbzip2
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL pbzip2
    mkdir -p tmp
    touch tmp/a.txt
    echo 'hello' >> tmp/a.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ! bzip2 --help 2>&1 | grep 'Bad flag' && bzip2 --help 2>&1 | grep 'usage: bzip2'
    CHECK_RESULT $? 0 0 "Failed option: help"
    ! bzip2 --version 2>&1 < /dev/null | grep 'Bad flag' && bzip2 --version 2>&1 < /dev/null | grep 'Version'
    CHECK_RESULT $? 0 0 "Failed option: version"
    bzip2 tmp/a.txt && ls tmp/ | grep 'a.txt.bz2'
    CHECK_RESULT $? 0 0 "Failed option: bzip2 without save old file" 
    bzip2 -d tmp/a.txt.bz2 && ls tmp/ | grep -cE 'a.txt'
    CHECK_RESULT $? 0 0 "Failed option: bzip2 decompress"
    bzip2 -c tmp/a.txt 2>&1 < /dev/null | head -n1 | grep 'BZh' 
    CHECK_RESULT $? 0 0 "Failed option: stdout" 
    bzip2 -k tmp/a.txt && ls tmp/ | grep -cE 'a.txt|a.txt.bz2' | grep '2'
    CHECK_RESULT $? 0 0 "Failed option: keep (don't delete) input files"
    bzip2 -f tmp/a.txt && ls tmp/ | grep 'a.txt.bz2'
    CHECK_RESULT $? 0 0 "Failed option: bzip2 force"
    bzip2 -t tmp/a.txt.bz2 
    CHECK_RESULT $? 0 0 "Failed option: bzip2 force"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
