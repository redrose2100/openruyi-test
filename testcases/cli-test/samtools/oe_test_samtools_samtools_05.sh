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
# @Date      	:   2022-8-23
# @License   	:   Mulan PSL v2
# @Desc      	:   test statistic
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL samtools
    test -d tmp || mkdir tmp
    cp ./common/fst.bed ./tmp/fst.bed
    cp ./common/fst.bam ./tmp/fst.bam
    samtools index ./tmp/fst.bam
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    samtools bedcov ./tmp/fst.bed ./tmp/fst.bam 2>&1 | grep "chrX"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools bedcov"
    samtools coverage ./tmp/fst.bam 2>&1 | grep "chrX"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools coverage"
    samtools depth ./tmp/fst.bam 2>&1 | grep "chrX"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools depth"
    samtools flagstat ./tmp/fst.bam 2>&1 | grep "secondary"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools flagstat"
    samtools idxstats ./tmp/fst.bam 2>&1 | grep "chr1"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools idxstats"
    samtools phase ./tmp/fst.bam 2>&1 | grep "chrX"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools phase"
    samtools stats ./tmp/fst.bam 2>&1 | grep "GCD"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools stats"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
