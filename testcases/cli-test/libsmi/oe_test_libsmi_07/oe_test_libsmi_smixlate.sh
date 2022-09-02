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
    smixlate -V 2>&1 | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
    smixlate -h 2>&1 | grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -c /usr/share/mibs/ietf/* 2>&1 | grep "/usr/share/mibs" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -p IF-MIB /usr/share/mibs/ietf/* 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -r IF-MIB /usr/share/mibs/ietf/* 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: -r, --recursive No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -l 6 /usr/share/mibs/ietf/* 2>&1 | grep -e "warning" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -i huawei /usr/share/mibs/ietf/* 2>&1 | grep -e "ifType"
    CHECK_RESULT $? 0 0 "L$LINENO: -i, --ignore=prefix No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -I huawei /usr/share/mibs/ietf/* 2>&1 | grep -e "ifType"
    CHECK_RESULT $? 0 0 "L$LINENO: -I, --noignore=prefix No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -a 2>&1 | grep -e "mib"
    CHECK_RESULT $? 0 0 "L$LINENO: -a, --all  No Pass"
    echo "what is this oid? 1.3.6.1.2.1.2.2.1.3" | smixlate -f /usr/share/mibs/ietf/* 2>&1 | grep -e "ifType"
    CHECK_RESULT $? 0 0 "L$LINENO: -f, --format No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./IF-MIB*
    LOG_INFO "End to restore the test environment."
}

main "$@"
