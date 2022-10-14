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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smicache."
    smicache -V | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    smicache -h | grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    smicache -d /tmp 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -d dir No Pass"
    smicache -p "www.baidu.com" 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -p prefix No Pass"
    smicache mib IF-MIB 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: mib No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./IF-MIB* 
    LOG_INFO "End to restore the test environment."
}

main "$@"
