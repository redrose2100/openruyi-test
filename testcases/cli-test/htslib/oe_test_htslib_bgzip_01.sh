#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   chen zebin
# @Contact   	:   zebin@isrc.iscas.ac.cn
# @Date      	:   2022-8-13
# @License   	:   Mulan PSL v2
# @Desc      	:   test bgzip compress and decompress
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL htslib-tools
    test -d tmp || mkdir tmp
    cp ./common/fst.gff ./tmp/fst.gff
    cp ./common/fst.gff ./tmp/snd.gff
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    bgzip -h 2>&1 | grep "Usage:   bgzip"
    CHECK_RESULT $? 0 0 "Failed to run command:bgzip -h"
    bgzip --version 2>&1 | grep "bgzip (htslib)"
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip --version "
    bgzip ./tmp/fst.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip"
    md5sum ./tmp/fst.gff.gz >./tmp/bgzip1.md5
    md5sum -c ./tmp/bgzip1.md5 | grep "fst.gff.gz"
    bgzip -t ./tmp/fst.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -t"
    md5sum ./tmp/fst.gff.gz >./tmp/bgzip2.md5
    md5sum -c ./tmp/bgzip2.md5 | grep "fst.gff.gz"
    bgzip -d ./tmp/fst.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -d"
    md5sum ./tmp/fst.gff >./tmp/bgzip3.md5
    md5sum -c ./tmp/bgzip3.md5 | grep "fst.gff"
    bgzip -@ 2 ./tmp/fst.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -@"
    md5sum ./tmp/fst.gff.gz >./tmp/bgzip4.md5
    md5sum -c ./tmp/bgzip4.md5 | grep "fst.gff.gz"
    bgzip -c ./common/snd.gff >./tmp/snd.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command :bgzip -c"
    grep 15MW ./tmp/snd.gff.gz
    bgzip -l 2 ./tmp/snd1.gff >./tmp/snd1.gff.gz 2>&1
    md5sum ./tmp/snd1.gff.gz >./tmp/bgzip6.md5
    md5sum -c ./tmp/bgzip6.md5 | grep "snd1.gff.gz"
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -l"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
