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
    LOG_INFO "End to prepare the test environment"
}
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_libsmi_smilint."
    smilint -V | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
    smilint -h 2>&1 | grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
    smilint -c /etc/smi.conf 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
    smilint -p /usr/share/mibs/ietf/IF-MIB 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
    smilint -e | grep -e "Message" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -e, --error-list No Pass"
    smilint -m 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -m, --error-names No Pass"
    smilint -s 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -s, --severity No Pass"
    smilint -r 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -r, --recursive No Pass"
    smilint -l 3 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
    smilint -i huawei 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -i, --ignore=prefix No Pass"
    smilint -I huawei 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: --noignore=prefix No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
