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

# @Desc      	:   test samtools indexing
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    test -d tmp || mkdir tmp
    cp ./common/6PYB ./tmp/6PYB
    cp ./common/fst.bam ./tmp/fst.bam
    DNF_INSTALL samtools
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    samtools dict -a GRCh38 -s "Homo sapiens" ./tmp/6PYB 2>&1 | grep "Homo sapiens"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools dict -a -s"
    samtools faidx ./tmp/6PYB 2>&1 | ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep '6PYB.fai'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools faidx"
    samtools index ./tmp/fst.bam 2>&1
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'fst.bam.bai'
    CHECK_RESULT $? 0 0 "Failed to run command: samtools index"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
