#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan 678PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
#
# @Author    	:   chen zebin
# @Contact   	:   zebin@isrc.iscas.ac.cn
# @Date      	:   2022-8-13
# @License   	:   Mulan PSL v2
# @Desc      	:   test bgzip
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL htslib-tools
    test -d tmp || mkdir tmp
    cp ./common/fst.gff ./tmp/trd.gff
    cp ./common/fnd.gff ./tmp/fnd.gff
    cp ./common/ffd.gff ./tmp/ffd.gff
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    bgzip -i ./tmp/trd.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -i"
    md5sum ./tmp/trd.gff.gz ./tmp/trd.gff.gz.gzi >./tmp/bgzip1.md5
    md5sum -c ./tmp/bgzip1.md5 | grep "trd.gff.gz\|trd.gff.gz.gzi"
    bgzip -r ./tmp/trd.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -r"
    md5sum ./tmp/trd.gff.gz.gzi >./tmp/bgzip2.md5
    md5sum -c ./tmp/bgzip2.md5 | grep "trd.gff.gz.gzi"
    bgzip -g ./tmp/fnd.gff -I ./tmp/trd.gff.gz.gzi 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -g"
    md5sum ./tmp/fnd.gff.gz >./tmp/bgzip3.md5
    md5sum -c ./tmp/bgzip3.md5 | grep "fnd.gff.gz"
    bgzip -b 0.1 ./tmp/trd.gff.gz 2>&1 | grep "gff-version"
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -b"
    md5sum ./tmp/trd.gff.gz >./tmp/bgzip4.md5
    md5sum -c ./tmp/bgzip4.md5 | grep "trd.gff.gz"
    bgzip -s 1 ./tmp/trd.gff.gz 2>&1 >./tmp/trd.gff
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -s"
    grep "4Hvu" ./tmp/trd.gff
    bgzip -f ./tmp/ffd.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -f"
    md5sum ./tmp/ffd.gff.gz >./tmp/bgzip5.md5
    md5sum -c ./tmp/bgzip5.md5 | grep "ffd.gff.gz"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
