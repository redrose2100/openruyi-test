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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smidump_02."
    smidump -f cm IF-MIB >result.cm 2>&1 && grep -e "diagram" result.cm
    CHECK_RESULT $? 0 0 "L$LINENO: -f cm No Pass"
    smidump -f cm --cm-explain IF-MIB | grep -e "Conceptual model of: IF-MIB"
    CHECK_RESULT $? 0 0 "L$LINENO: -f cm --cm-explain No Pass"
    smidump -f corba IF-MIB >result.corba
    CHECK_RESULT $? 0 0 "L$LINENO: -f corba No Pass"
    smidump -f identifiers IF-MIB >result.identifiers 2>&1 && grep -e "# IF-MIB list of identifiers" result.identifiers
    CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers No Pass"
    smidump -f identifiers --identifiers-lines IF-MIB > result.identifiers && grep -E "[[:digit:]]*" result.identifiers | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers --identifiers-lines No Pass"
    smidump -f identifiers --identifiers-path IF-MIB > result.identifiers && grep -E "[[/.*/]]*" result.identifiers| head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers --identifiers-path No Pass"
    smidump -f identifiers --identifiers-ctag IF-MIB > result.identifiers && grep 'OBJECT' result.identifiers | head -10
    CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers --identifiers-ctag No Pass"
    smidump -f imports IF-MIB > result.imports 2>&1 && grep -e "+--" result.imports
    CHECK_RESULT $? 0 0 "L$LINENO: -f imports No Pass"
    smidump -f jax IF-MIB 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -f jax imports No Pass"
    smidump -f jax --jax-package=string IF-MIB 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -f jax --jax-package imports No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./result* ./IF_MIB* ./IF-MIB*
    rm -rf ./*.java
    LOG_INFO "End to restore the test environment."
}

main "$@"
