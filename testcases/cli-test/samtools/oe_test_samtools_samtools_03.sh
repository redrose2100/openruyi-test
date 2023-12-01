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
# @Desc      	:   test samtools file operation
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL samtools
    test -d tmp || mkdir tmp
    cp ./common/fst.bam ./tmp/fst.bam
    cp ./common/fst.bam ./tmp/snd.bam
    cp ./common/6PYB ./tmp/6PYB
    samtools index ./tmp/fst.bam
    samtools index ./tmp/snd.bam
    samtools addreplacerg -r ID:bar -r SM:barney -o ./tmp/fstout.bam ./tmp/fst.bam
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    samtools collate ./tmp/fst.bam ./tmp/snd.bam 2>&1
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'snd.bam.bam'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools collate -a -s"
    samtools cat -o ./tmp/snd.bam ./tmp/fst.bam 2>&1
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'snd.bam'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools cat"
    samtools merge ./tmp/trd.bam ./tmp/fst.bam ./tmp/snd.bam 2>&1
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'trd.bam'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools merge"
    samtools mpileup -C50 -f ./tmp/6PYB -r chr3:1,000-1,500 ./tmp/fst.bam ./tmp/snd.bam 2>&1 | grep "mpileup"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools mplieup -C50 -f -r"
    samtools sort ./tmp/fst.bam -o ./tmp/fst.sorted.bam 2>&1
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'fst.sorted.bam'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools sort"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp
}

main "$@"
