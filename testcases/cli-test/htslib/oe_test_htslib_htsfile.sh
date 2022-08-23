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
# @Desc      	:   test htslib htsfile
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL htslib-tools
    test -d tmp || mkdir tmp
    cp ./common/snd.gff ./tmp/sev.bam
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    htsfile --version 2>&1 | grep "htsfile (htslib)"
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile --version"
    htsfile -c ./tmp/sev.bam 2>&1 | grep "SOLEXA"
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -c"
    htsfile -C ./tmp/sev.bam ./tmp/sev1.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -C"
    md5sum ./tmp/sev1.bam >./tmp/bgzip.md5
    md5sum -c ./tmp/bgzip.md5 | grep "sev1.bam"
    htsfile -h ./tmp/sev1.bam 2>&1 | grep "@SQ"
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -h"
    htsfile -H ./tmp/sev.bam 2>&1 | grep "BAM version"
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -H"
    htsfile -v ./tmp/sev.bam 2>&1 | grep "BAM version"
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -v"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
