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
    mkdir -p tmp1/
    touch tmp1/b.txt
    echo 'hello' >> tmp1/b.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    bzip2 -kz tmp1/b.txt && ls tmp1/ | grep -cE 'b.txt|b.txt.bz2' | grep '2'
    CHECK_RESULT $? 0 0 "Faileerbosd option: compress"
    rm -rf tmp1/b.txt.bz2 && bzip2 -kv tmp1/b.txt 2>&1 < /dev/null | grep 'tmp1/b.txt:'
    CHECK_RESULT $? 0 0 "Faileerbosd option: verbose"
    rm -rf tmp1/b.txt.bz2 && bzip2 -k -q tmp1/b.txt
    CHECK_RESULT $? 0 0 "Failed option: quiet"  
    bzip2 -L 2>&1 < /dev/null | head -n1| grep 'bzip2' 
    CHECK_RESULT $? 0 0 "Failed option: license"  
    rm -rf tmp1/b.txt.bz2 && bzip2 -ks tmp1/b.txt && ls tmp1/ | grep -cE 'b.txt|b.txt.bz2' | grep '2'
    CHECK_RESULT $? 0 0 "Failed option: small"
    rm -rf tmp1/b.txt.bz2 && bzip2 -1kv tmp1/b.txt 2>&1 < /dev/null | grep 'tmp1/b.txt:'
    CHECK_RESULT $? 0 0 "Failed option: set block size to 100k"
    rm -rf tmp1/b.txt.bz2 && bzip2 --fast -k tmp1/b.txt && ls tmp1/ | grep -cE 'b.txt|b.txt.bz2' | grep '2'
    CHECK_RESULT $? 0 0 "Failed option: alias for -1"
    rm -rf tmp1/b.txt.bz2 && bzip2 --best -k tmp1/b.txt && ls tmp1/ | grep -cE 'b.txt|b.txt.bz2' | grep '2'
    CHECK_RESULT $? 0 0 "Failed option: alias for -9"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
