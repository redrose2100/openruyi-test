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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smistrip."
    smistrip -V 2>&1 | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    smistrip -h 2>&1 | grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    smistrip -n IF-MIB 2>&1 | grep -e "IF-MIB"
    CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
    smistrip -i /etc/smi.conf 2>&1 | grep -e "cat"
    CHECK_RESULT $? 0 0 "L$LINENO: -i dir No Pass"
    smistrip -d ./ /usr/share/mibs/ietf/ADSL-TC-MIB 2>&1 | grep -e "ADSL-TC-MIB:" && rm -rf ADSL-TC-MIB
    CHECK_RESULT $? 0 0 "L$LINENO: -d dir No Pass"
    smistrip -m ADSL-TC-MIB /usr/share/mibs/ietf/ADSL-TC-MIB 2>&1 | grep -e "ADSL-TC-MIB:"
    CHECK_RESULT $? 0 0 "L$LINENO: -m module No Pass"
    smistrip IF-MIB | grep -e "IF-MIB:"
    CHECK_RESULT $? 0 0 "L$LINENO: file1 ... No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./IF-MIB* ./ADSL-TC-MIB*
    LOG_INFO "End to restore the test environment."
}

main "$@"
