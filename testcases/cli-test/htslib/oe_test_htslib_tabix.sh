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
# @Desc      	:   test htslib tabix
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL htslib-tools
    test -d tmp || mkdir tmp
    cp ./common/fst.gff ./tmp/six.gff
    sort -k1,1 -k4,4n ./tmp/six.gff >./tmp/six.sorted.gff
    bgzip ./tmp/six.sorted.gff
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    tabix --version 2>&1 | grep "tabix (htslib)"
    CHECK_RESULT $? 0 0 "Failed to run command:tabix --version"
    tabix -p gff ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -p"
    md5sum ./tmp/six.sorted.gff.gz.tbi >./tmp/bgzip1.md5
    md5sum -c ./tmp/bgzip1.md5 | grep "six.sorted.gff.gz.tbi"
    tabix -0 -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -0 -f"
    md5sum ./tmp/six.sorted.gff.gz.tbi >./tmp/bgzip2.md5
    md5sum -c ./tmp/bgzip2.md5 | grep "six.sorted.gff.gz.tbi"
    tabix -b 4 -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -b -f"
    md5sum ./tmp/six.sorted.gff.gz.tbi >./tmp/bgzip3.md5
    md5sum -c ./tmp/bgzip3.md5 | grep "six.sorted.gff.gz.tbi"
    tabix -c "#" -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -c -f"
    md5sum ./tmp/six.sorted.gff.tbi >./tmp/bgzip4.md5
    md5sum -c ./tmp/bgzip4.md5 | grep "six.sorted.gff.gz.tbi"
    tabix -C -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -C -f"
    md5sum ./tmp/six.sorted.gff.gz.csi >./tmp/bgzip5.md5
    md5sum -c ./tmp/bgzip5.md5 | grep "six.sorted.gff.gz.csi"
    tabix -e 5 -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -e -f"
    md5sum ./tmp/six.sorted.gff.tbi >./tmp/bgzip6.md5
    md5sum -c ./tmp/bgzip6.md5 | grep "six.sorted.gff.gz.tbi"
    tabix -m 14 -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -m -f"
    md5sum ./tmp/six.sorted.gff.csi >./tmp/bgzip7.md5
    md5sum -c ./tmp/bgzip7.md5 | grep "six.sorted.gff.gz.csi"
    tabix -s 1 -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -s -f"
    md5sum ./tmp/six.sorted.gff.tbi >./tmp/bgzip8.md5
    md5sum -c ./tmp/bgzip8.md5 | grep "six.sorted.gff.gz.tbi"
    tabix -S 0 -f ./tmp/six.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:tabix -S -f"
    md5sum ./tmp/six.sorted.gff.tbi >./tmp/bgzip9.md5
    md5sum -c ./tmp/bgzip9.md5 | grep "six.sorted.gff.gz.tbi"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
