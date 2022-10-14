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
    LOG_INFO "Start to run testcase:oe_test_libsmi_smidump_05."
    smidump -f svg IF-MIB >result.svg 2>&1 && grep -e "//SVG - Learning By Coding" result.svg
    CHECK_RESULT $? 0 0 "L$LINENO: -f svg No Pass"
    smidump -f svg --svg-width=100 IF-MIB >result.svg 2>&1 && grep -e 'width="100"' result.svg | head -10
    CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-width=number No Pass"
    smidump -f svg --svg-height=700 IF-MIB >result.svg 2>&1 && grep -e 'height="700"' result.svg | head -10
    CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-height=number No Pass"
    smidump -f svg --svg-show-deprecated IF-MIB >result.svg 2>&1 && grep -e "deprecated" result.svg | head -2
    CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-show-deprecated No Pass"
    smidump -f svg --svg-show-depr-obsolete IF-MIB >result.svg 2>&1 && grep -e "deprecated" result.svg | head -2
    CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-show-depr-obsolete No Pass"
    smidump -f svg --svg-static-output IF-MIB >result.svg 2>&1 && grep -e "Conceptual model of IF-MIB - generated" result.svg
    CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-static-output No Pass"
    smidump -f tree IF-MIB >result.tree 2>&1 && grep -e "internet" result.tree
    CHECK_RESULT $? 0 0 "L$LINENO: -f tree No Pass"
    smidump -f tree --tree-no-conformance IF-MIB >result.tree 2>&1 && grep -e "internet" result.tree
    CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-no-conformance No Pass"
    smidump -f tree --tree-no-leafs IF-MIB >result.tree 2>&1 && grep -e "internet" result.tree
    CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-no-leafs No Pass"
    smidump -f tree --tree-full-root IF-MIB >result.tree 2>&1 && grep -e "internet" result.tree
    CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-full-root No Pass"
    smidump -f tree --tree-compact IF-MIB >result.tree 2>&1 && grep -e "internet" result.tree
    CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-compact No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./result* ./IF_MIB* ./IF-MIB* ./if-mib*
    LOG_INFO "End to restore the test environment."
}

main "$@"
