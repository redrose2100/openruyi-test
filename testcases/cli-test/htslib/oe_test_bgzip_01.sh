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
# @Desc      	:   test bgzip compress & decompress
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL htslib zlib-devel bzip2 bzip2-devel xz-devel -y
    wget http://www.candidagenome.org/download/gff/C_albicans_SC5314/Assembly19/A19_ForcheSNPs.gff -O /tmp/fst.gff
    wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBjG2AlnRep1.bam -O /tmp/snd.gff
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    bgzip -h 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:bgzip -h"
    bgzip --version 2>&1 | grep "bgzip (htslib) 1.10.2"
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip --version "
    bgzip fst.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to compress file"
    bgzip -t fst.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -t"
    bgzip -d fst.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -d"
    bgzip -@ 2 fst.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -@ 2"
    bgzip -c snd.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command :bgzip -c"
    bgzip -l 2 snd.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -l"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
