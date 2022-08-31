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
    mkdir tmp
    mwget https://github.com/samtools/samtools/releases/download/1.16/samtools-1.16.tar.bz2 -f ./tmp/samtools-1.16.tar.bz2
    mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBg02esG1bAlnRep1.bam -f ./tmp/fst.bam
    mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBjS1AlnRep1.bam -f ./tmp/snd.bam
    mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqGm12813S3AlnRep1.bam -f ./tmp/trd.bam
    mwget https://www.rcsb.org/fasta/entry/6PYB -f ./tmp/6PYB
    tar jxvf ./tmp/samtools-1.16.tar.bz2 -C ./tmp
    cd ./tmp/samtools-1.16
    ./configure --prefix=${OET_PATH}/testcases/cli-test/samtools/tmp/samtools-1.16
    make && make install
    echo "export SAMTOOLPATH=${OET_PATH}/testcases/cli-test/samtools/tmp/samtools-1.16" >>/etc/profile
    echo "export PATH=$SAMTOOLPATH/bin:$PATH" >>/etc/profile
    source ~/.bashrc
    samtools index ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam
    samtools index ${OET_PATH}/testcases/cli-test/samtools/tmp/snd.bam
    samtools addreplacerg -r ID:bar -r SM:barney -o ${OET_PATH}/testcases/cli-test/samtools/tmp/fstout.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    samtools collate ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/snd.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools collate -a -s"
    samtools cat -o ${OET_PATH}/testcases/cli-test/samtools/tmp/snd.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools cat"
    samtools consensus -o ${OET_PATH}/testcases/cli-test/samtools/tmp/fstout.fastq ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools consensus -o"
    samtools merge ${OET_PATH}/testcases/cli-test/samtools/tmp/fnd.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/snd.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools merge"
    samtools mpileup -C50 -f ${OET_PATH}/testcases/cli-test/samtools/tmp/6PYB -r chr3:1,000-1,500 ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/snd.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools mplieup -C50 -f -r"
    samtools sort ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam -o ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.sorted.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools sort -o"
    samtools split ${OET_PATH}/testcases/cli-test/samtools/tmp/fstout.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools split"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ${OET_PATH}/testcases/cli-test/samtools/tmp
}
main "$@"
