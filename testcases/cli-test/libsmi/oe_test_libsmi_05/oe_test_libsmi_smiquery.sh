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
#@Date      :   2022/8/31
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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smiquery."
    smiquery -V | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
    smiquery -h 2>&1 | grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
    smiquery -c /etc/smi.conf 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
    smiquery -p IF-MIB 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
    smiquery module IF-MIB 2>&1 | grep -e "Description"
    CHECK_RESULT $? 0 0 "L$LINENO: module <module> No Pass"
    smiquery imports IF-MIB 2>&1 | grep -e "Imports"
    CHECK_RESULT $? 0 0 "L$LINENO: imports <module> No Pass"
    smiquery node IF-MIB::ifNumber 2>&1 | grep -e "OID"
    CHECK_RESULT $? 0 0 "L$LINENO: node <module::name> No Pass"
    smiquery compliance IF-MIB::ifCompliance3 2>&1 | grep -e "Description:"
    CHECK_RESULT $? 0 0 "L$LINENO: compliance <module::name> No Pass"
    smiquery children IF-MIB::ifNumber 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: children <module::name> No Pass"
    smiquery type IF-MIB::ifNumber 2>&1 | grep -e "Type"
    CHECK_RESULT $? 0 0 "L$LINENO: type <module::name> No Pass"
    smiquery macro IF-MIB::ifNumber 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: macro <module::name>  No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./IF-MIB*
    LOG_INFO "End to restore the test environment."
}

main "$@"
