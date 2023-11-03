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
# @Desc      	:   test samtools editing
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL samtools
    test -d tmp || mkdir tmp
    cp ./common/fstsorted.bam ./tmp/fstsorted.bam
    cp ./common/fstnamesort.bam ./tmp/fstnamesort.bam
    cp ./common/6PYB ./tmp/6PYB
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    samtools fixmate ./tmp/fstnamesort.bam ./tmp/fstnameout.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools fixmate"
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'fstnameout.bam'
    samtools targetcut -f ./tmp/6PYB ./tmp/fstsorted.bam 2>&1 | grep "[W::fai_get_val]"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools targetcut"
    samtools addreplacerg -r ID:bar -r SM:barney ./tmp/fstsorted.bam 2>&1 | grep "GCAGTGAGCCAAGATCACGCCACCCCACT"
    CHECK_RESULT $? 0 0 "Failed to run command: samtools addreplacerg"
    samtools markdup ./tmp/fstsorted.bam ./tmp/fstout.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: samtools markup"
    ls ${OET_PATH}/testcases/cli-test/samtools/tmp/ | grep 'fstout.bam'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
