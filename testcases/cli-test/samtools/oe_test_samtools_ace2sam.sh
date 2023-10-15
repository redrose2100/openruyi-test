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
# @Desc      	:   test samtools ace2sam, export2sam.pl, novo2sam.pl, psl2sam.pl, samtools.pl.
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL samtools
    test -d tmp || mkdir tmp
    cp ./common/acefile.ace ./tmp/acefile.ace
    cp ./common/fst.bed ./tmp/fst.bed
    cp ./common/fst.novo ./tmp/fst.novo
    cp ./common/fst.bam ./tmp/fst.bam
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ace2sam -p ./tmp/acefile.ace 2>&1 | grep "@SQ"
    CHECK_RESULT $? 0 0 "Failed to run command:ace2sam -p"
    ace2sam -c ./tmp/acefile.ace 2>&1 | grep "@SQ"
    CHECK_RESULT $? 0 0 "Failed to run command:ace2sam -c"
    export2sam.pl --version 2>&1 | grep "version"
    CHECK_RESULT $? 0 0 "Failed to run command:export2sam.pl --version "
    export2sam.pl --read1=./tmp/fst.bed --qlogodds | grep "@PG"
    CHECK_RESULT $? 0 0 "Failed to run command:export2sam.pl --read1 --qlogodds00"
    novo2sam.pl -p ./tmp/fst.novo 2>&1 | grep string
    CHECK_RESULT $? 0 0 "Failed to run command:novo2sam.pl -p"
    psl2sam.pl -a 1 -b 3 ./tmp/fst.bam 2>&1 | grep "Argument"
    CHECK_RESULT $? 0 0 "Failed to run command:psl2sam.pl" 7 0 "The system is missing a base directory."
    samtools.pl showALEN ./tmp/fst.bam 2>&1 | grep "BC"
    CHECK_RESULT $? 0 0 "Failed to run command:samtools.pl showALEN"
    samtools.pl varFilter ./tmp/fst.bam 2>&1 | grep "Argument"
    CHECK_RESULT $? 0 0 "Failed to run command:samtools.pl varFilter"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
