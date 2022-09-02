#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2022/8/30
#@License   :   Mulan PSL v2
#@Desc      :   Test "libsmi" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "libsmi"
    cp /usr/share/mibs/ietf/IF-MIB IF-MIB
    LOG_INFO "End to prepare the test environment"
}
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_libsmi_smidump_03."
    smidump -f metrics  IF-MIB > result.metrics 2>&1 && grep -e '%' result.metrics | head -10
    CHECK_RESULT $? 0 0 "L$LINENO: -f metrics No Pass"
    smidump -f metrics --metrics-raw IF-MIB > result.metrics 2>&1 && grep -E [0-9] result.metrics | head -10
    CHECK_RESULT $? 0 0 "L$LINENO: -f metrics --metrics-raw No Pass"
    smidump -f mosy  IF-MIB > result.mosy 2>&1 && grep -e '%' result.mosy | head -10
    CHECK_RESULT $? 0 0 "L$LINENO: -f mosy No Pass"
    smidump -f netsnmp  IF-MIB 2>&1 
    CHECK_RESULT $? 0 0 "L$LINENO: -f netsnmp No Pass"
    smidump -f netsnmp --netsnmp-no-mgr-stubs  IF-MIB 2>&1 
    CHECK_RESULT $? 0 0 "L$LINENO: -f netsnmp --netsnmp-no-mgr-stubs No Pass"
    smidump -f netsnmp --netsnmp-no-agt-stubs  IF-MIB 2>&1 
    CHECK_RESULT $? 0 0 "L$LINENO: -f netsnmp --netsnmp-no-agt-stubs No Pass"
    smidump -f perl  IF-MIB > result.perl 2>&1 && grep -e "# Perl version" result.perl
    CHECK_RESULT $? 0 0 "L$LINENO: -f perl No Pass"
    smidump -f python  IF-MIB > result.python 2>&1 && grep -e "# python version" result.python
    CHECK_RESULT $? 0 0 "L$LINENO: -f python No Pass"
    smidump -f sming  IF-MIB > result.sming 2>&1 && grep -e "module IF-MIB" result.sming
    CHECK_RESULT $? 0 0 "L$LINENO: -f sming No Pass"
    smidump -f smiv1  IF-MIB > result.smiv1 2>&1 && grep -e "IF-MIB DEFINITIONS ::= BEGIN" result.smiv1
    CHECK_RESULT $? 0 0 "L$LINENO: -f smiv1 No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./result* ./IF_MIB* ./IF-MIB* ./if-mib*
    LOG_INFO "End to restore the test environment."
}

main "$@"
