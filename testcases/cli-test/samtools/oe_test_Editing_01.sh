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
# @Desc      	:   test samtools editing function
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
	LOG_INFO "Start environmental preparation."
	mkdir tmp
	mwget https://github.com/samtools/samtools/releases/download/1.16/samtools-1.16.tar.bz2 -f ./tmp/samtools-1.16.tar.bz2
	mwget https://www.rcsb.org/fasta/entry/6PYB -f ./tmp/6PYB
	mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBg02esG1bAlnRep1.bam -f ./tmp/fst.bam
	mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBg02esG1bAlnRep1.bam -f ./tmp/snd.bam
	mwget https://zenodo.org/record/3736457/files/1_control_18S_2019_minq7%20-%20Copy.fastq?download=1 -f ./tmp/fst.fastq
	mwget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBjValleysRep2.bed.gz -f ./tmp/bfile.bed.gz
	gunzip ${OET_PATH}/testcases/cli-test/samtools/tmp/bfile.bed.gz
	tar jxvf ./tmp/samtools-1.16.tar.bz2 -C ./tmp
	cd ./tmp/samtools-1.16
	./configure --prefix=${OET_PATH}/testcases/cli-test/samtools/tmp/samtools-1.16
	make && make install
	echo "export SAMTOOLPATH=${OET_PATH}/testcases/cli-test/samtools/tmp/samtools-1.16" >>/etc/profile
	echo "export PATH=$SAMTOOLPATH/bin:$PATH" >>/etc/profile
	source ~/.bashrc
	samtools sort -o ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.sorted.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam
	samtools sort -n -o ${OET_PATH}/testcases/cli-test/samtools/tmp/fstnamesort.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam
	LOG_INFO "End of environmental preparation!"
}
function run_test() {
	LOG_INFO "Start testing..."
	samtools calmd ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.sorted.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/6PYB 2>&1
	CHECK_RESULT $? 0 0 "Failed to run command: samtools calmd"
	samtools fixmate ${OET_PATH}/testcases/cli-test/samtools/tmp/fstnamesort.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/tnd.bam 2>&1
	CHECK_RESULT $? 0 0 "Failed to run command: samtools fixmate"
	samtools targetcut -f ${OET_PATH}/testcases/cli-test/samtools/tmp/6PYB ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.sorted.bam 2>&1
	CHECK_RESULT $? 0 0 "Failed to run command: samtools targetcut"
	samtools addreplacerg -r ID:bar -r SM:barney ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.sorted.bam 2>&1
	CHECK_RESULT $? 0 0 "Failed to run command: samtools addreplacerg"
	samtools markdup ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.sorted.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fstout.bam 2>&1
	CHECK_RESULT $? 0 0 "Failed to run command: samtools markup"
	samtools ampliconclip -b ${OET_PATH}/testcases/cli-test/samtools/tmp/bfile.bed -o ${OET_PATH}/testcases/cli-test/samtools/tmp/fstbed.bam ${OET_PATH}/testcases/cli-test/samtools/tmp/fst.bam
	CHECK_RESULT $? 0 0 "Failed to run command: samtools ampliconclip"
	LOG_INFO "Finish test!"
}
function post_test() {
	LOG_INFO "start environment cleanup."
	DNF_REMOVE
	rm -rf ${OET_PATH}/testcases/cli-test/samtools/tmp
	LOG_INFO "Finish environment cleanup!"
}
main "$@"
