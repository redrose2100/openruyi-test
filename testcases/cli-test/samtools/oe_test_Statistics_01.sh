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
    mkdir tmp
    mwget https://github.com/samtools/samtools/releases/download/1.16/samtools-1.16.tar.bz2 -f ./tmp/samtools-1.16.tar.bz2
    mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBg02esG1bAlnRep1.bam -f ./tmp/fst.bam
    mwget https://zenodo.org/record/3736457/files/1_control_ITS2_2019_minq7.fastq?download=1 -f ./tmp/fstt.fastq
    mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBg02esValleysRep1.bed.gz -f ./tmp/file1.bed.gz
    gunzip ./tmp/file1.bed.gz
    tar jxvf ./tmp/samtools-1.16.tar.bz2 -C ./tmp
    cd ./tmp/samtools-1.16
    ./configure --prefix=${OET_PATH}/testcases/cli-test/samtools/tmp/samtools-1.16
    make && make install
    echo "export SAMTOOLPATH=${OET_PATH}/testcases/cli-test/samtools/tmp/samtools-1.16" >>/etc/profile
    echo "export PATH=$SAMTOOLPATH/bin:$PATH" >>/etc/profile
    source ~/.bashrc
    samtools index ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    samtools bedcov ${OET_PATH}/testcases/cli-test/samtools/tmp/file1.bed ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools bedcov"
    samtools coverage ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools coverage"
    samtools depth ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools depth"
    samtools flagstat ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools flagstat"
    samtools idxstats ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools idxstats"
    samtools phase ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools phase"
    samtools stats ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools stats"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ${OET_PATH}/testcases/cli-test/samtools/tmp
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
