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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smidump_07."
    smidump -f xsd IF-MIB >result.xsd 2>&1 && grep -e "xsd" result.xsd | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -f xsd No Pass"
    smidump -f xsd --xsd-schema-url=huawei  IF-MIB >result.xsd 2>&1 && grep -e "huawei" result.xsd | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-schema-url=string No Pass"
    smidump -f xsd --xsd-container IF-MIB >result.xsd 2>&1 && grep -e "container" result.xsd
    CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-container No Pass"
    smidump -f xsd --xsd-nest-augments IF-MIB >result.xsd 2>&1 && grep -e "xsd" result.xsd | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-nest-augments No Pass"
    smidump -f xsd  --xsd-nest-subtables IF-MIB >result.xsd 2>&1 && grep -e "xsd" result.xsd | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-nest-subtables No Pass"
    smidump -f yang IF-MIB >result.yang 2>&1 && grep -e "module IF-MIB" result.yang
    CHECK_RESULT $? 0 0 "L$LINENO: -f yang No Pass"
    smidump -f yang --yang-smi-extensions IF-MIB >result.yang 2>&1 && grep -e "module IF-MIB" result.yang
    CHECK_RESULT $? 0 0 "L$LINENO: -f yang --yang-smi-extensions No Pass"
    smidump -f yang --yang-no-notifications IF-MIB >result.yang 2>&1 && grep -e "module IF-MIB" result.yang
    CHECK_RESULT $? 0 0 "L$LINENO: -f yang --yang-no-notifications No Pass"
    smidump -f yang --yang-indent=4 IF-MIB >result.yang 2>&1 && grep -e "module IF-MIB" result.yang
    CHECK_RESULT $? 0 0 "L$LINENO: -f yang --yang-indent=number No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./result* ./IF_MIB* ./IF-MIB* ./if-mib*
    LOG_INFO "End to restore the test environment."
}

main "$@"
