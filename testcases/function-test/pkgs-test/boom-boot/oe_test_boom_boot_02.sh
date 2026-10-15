#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   jiangchenyang
#@Contact   :   jiangcy1129@163.com
#@Date      :   2023/9/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "boom-boot" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "boom-boot"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_boom_boot_02."
    boom entry show -m "$(cat /etc/machine-id)" 
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    boom entry show --machine-id "$(cat /etc/machine-id)" 
    CHECK_RESULT $? 0 0 "L$LINENO: --machine-id No Pass"
    boom entry show --machineid "$(cat /etc/machine-id)" 
    CHECK_RESULT $? 0 0 "L$LINENO: --machineid No Pass"
    boom profile show -n "boom_profile" 
    CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
    boom profile show --name "boom_profile" 
    CHECK_RESULT $? 0 0 "L$LINENO: -name No Pass"
    boom profile show --name-prefixes 
    CHECK_RESULT $? 0 0 "L$LINENO: --name-prefixes No Pass"
    boom profile show --nameprefixes 
    CHECK_RESULT $? 0 0 "L$LINENO:  --nameprefixes No Pass"
    boom profile show --no-headings 
    CHECK_RESULT $? 0 0 "L$LINENO: --no-headings No Pass"
    boom profile show --noheadings 
    CHECK_RESULT $? 0 0 "L$LINENO: --noheadingsNo Pass"
    boom profile show --no-dev 
    CHECK_RESULT $? 0 0 "L$LINENO: --no-dev No Pass"
    boom profile show --nodev  
    CHECK_RESULT $? 0 0 "L$LINENO: --nodev  No Pass"
    boom profile show -o Name 
    CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
    boom profile show --options Name 
    CHECK_RESULT $? 0 0 "L$LINENO: --options No Pass"
    boom profile show --os-version "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: --os-version No Pass"
    boom profile show --osversion "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: --osversion No Pass"
    boom profile show -O Name 
    CHECK_RESULT $? 0 0 "L$LINENO: -O No Pass"
    boom profile show --sort Name 
    CHECK_RESULT $? 0 0 "L$LINENO: --sort No Pass"
    boom profile show -I "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: -O No Pass"
    boom profile show --os-version-id "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: --os-version-id No Pass"
    boom profile show --osversionid "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: --osversionid No Pass"
    boom profile show -os-options 
    CHECK_RESULT $? 0 0 "L$LINENO: --os-options No Pass"
    boom profile show -osoptions 
    CHECK_RESULT $? 0 0 "L$LINENO: --osoptions No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf boom.*
    LOG_INFO "End to restore the test environment."
}
main "$@"
