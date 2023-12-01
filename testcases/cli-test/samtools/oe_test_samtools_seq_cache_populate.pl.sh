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
# @Desc      	:   test samtools seq_cache_populate.pl, soap2sam.pl, wgsim_eval.pl, wgsim, zoom2sam.pl.
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test -d tmp || mkdir tmp
    cp ./common/6PYB ./tmp/6PYB
    cp ./common/fst.bam ./tmp/fst.bam
    cp ./common/fst.fa ./tmp/fst.fa
    cp ./common/fst.fq ./tmp/fst.fq
    cp ./common/snd.fq ./tmp/snd.fq
    cp ./common/fst.bed ./tmp/fst.bed
    DNF_INSTALL samtools
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    seq_cache_populate.pl -root ./tmp/ ./tmp/6PYB
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp | grep 68
    CHECK_RESULT $? 0 0 "Failed to run command:seq_cache_populate.pl -root"
    soap2sam.pl ./tmp/fst.bam 2>&1 | grep "Argument"
    CHECK_RESULT $? 0 0 "Failed to run command:soap2sam"
    wgsim_eval.pl alneval -p ./tmp/fst.bam 2>&1 | grep "Argument"
    CHECK_RESULT $? 0 0 "Failed to run command:wgsim_eval.pl alneval"
    wgsim ./tmp/fst.fa ./tmp/fst.fq ./tmp/snd.fq -d 500 -s 50 -1 90 -2 90 2>&1 | grep "wgsim"
    CHECK_RESULT $? 0 0 "Failed to run command:wgsim -d -s -1 -2"
    zoom2sam.pl -p 10 ./tmp/fst.bed 2>&1 | grep "macs_peak"
    CHECK_RESULT $? 0 0 "Failed to run command:wgsim -d -s -1 -2"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
