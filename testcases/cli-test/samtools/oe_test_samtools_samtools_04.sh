#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################F
# @Author    	:   chen zebin
# @Contact   	:   zebin@isrc.iscas.ac.cn
# @Date      	:   2022-8-23
# @License   	:   Mulan PSL v2
# @Desc      	:   test samtools file operation, viewing
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL samtools
    test -d tmp || mkdir tmp
    cp ./common/fst.bam ./tmp/snd.bam
    cp ./common/fst.bam ./tmp/trd.bam
    cp ./common/fst.bam ./tmp/fst.bam
    samtools index ./tmp/fst.bam
    samtools index ./tmp/snd.bam
    samtools index ./tmp/trd.bam
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    samtools fastq ./tmp/snd.bam 2>&1 | grep "hhh@UHMQMCNCECNCO"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools fastq"
    samtools fasta ./tmp/trd.bam >./tmp/trd.fasta 2>&1
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'trd.fasta'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools fasta"
    samtools flags PAIRED UNMAP MUNMAP 2>&1 | grep "Flags"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools flags"
    samtools tview -d T ./tmp/fst.bam 2>&1 | grep "1"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools tview -d T"
    samtools view -H ./tmp/fst.bam 2>&1 | grep "@PG"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools view -H"
    samtools help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools help"
    samtools version 2>&1 | grep "samtools"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools version"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
