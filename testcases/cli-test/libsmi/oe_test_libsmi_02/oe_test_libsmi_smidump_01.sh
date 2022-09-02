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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smidump_01."
    smidump -V | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
    smidump -h 2>&1 | grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
    smidump -q
    CHECK_RESULT $? 0 0 "L$LINENO: -q, --quiet No Pass"
    smidump -c /etc/smi.conf
    CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
    smidump -p /usr/share/mibs/ietf/SNMPv2-MIB
    CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
    smidump -l 3
    CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
    smidump -m
    CHECK_RESULT $? 0 0 "L$LINENO: -m, --error-names No Pass"
    smidump -s
    CHECK_RESULT $? 0 0 "L$LINENO: -s, --severity No Pass"
    smidump -o result
    CHECK_RESULT $? 0 0 "L$LINENO: -o, --output=name No Pass"
    smidump -u 2>&1| grep -e 'smidump'
    CHECK_RESULT $? 0 0 "L$LINENO: -u, --unified No Pass"
    smidump -k 
    CHECK_RESULT $? 0 0 "L$LINENO: -k, --keep-going No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf result ./result* ./IF_MIB* ./IF-MIB* ./if-mib*
    LOG_INFO "End to restore the test environment."
}

main "$@"
