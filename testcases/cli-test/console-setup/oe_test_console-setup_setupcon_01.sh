# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   chen zhenghao
# @Contact   	:   zhenghao@isrc.iscas.ac.cn
# @Date      	:   2023-2-23
# @License   	:   Mulan PSL v2
# @Desc      	:   the test of setupcon package
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL console-setup
    
    LOG_INFO "End to prepare the test environment."
}
function run_test() {

    LOG_INFO "Start to run test."
    setupcon -v 2>&1 | grep "The charmap is UTF-8 "
    CHECK_RESULT $? 0 0 "Check setupcon:  -v failed"
    setupcon --verbose 2>&1 | grep "The charmap is UTF-8"
    CHECK_RESULT $? 0 0 "Check setupcon:  --verbose failed"
    setupcon -k 2>&1 | grep "keyboard configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  -k failed"
    setupcon --keyboard-only 2>&1 | grep "keyboard configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  --keyboard-only failed"
      
    setupcon -f 2>&1 | grep "font configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  -f failed"
    setupcon --font-only 2>&1 | grep "font configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  --font-only failed"
      
    setupcon -t 2>&1 | grep "success"
    CHECK_RESULT $? 0 0 "Check setupcon:  -t failed"
    setupcon --terminal-only 2>&1 | grep "configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  --terminal-only failed"
    setupcon --current-tty 2>&1 | grep "configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  --current-tty failed"
    setupcon --force 2>&1 | grep "configuration success"
    CHECK_RESULT $? 0 0 "Check setupcon:  --force failed"
   
   LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"