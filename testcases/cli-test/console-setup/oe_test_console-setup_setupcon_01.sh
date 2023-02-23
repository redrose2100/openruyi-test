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

    LOG_INFO "No pkgs need to install."

    LOG_INFO "End to prepare the test environment."
}
function run_test() {

    LOG_INFO "Start to run test."
    setupcon -v 2>&1 | grep "The charmap is UTF-8 "
    setupcon --verbose 2>&1 | grep "The charmap is UTF-8"
    CHECK_RESULT $? 0 0 "Failed option:  -v, --verbose "
    setupcon -k 2>&1 | grep "keyboard configuration success"
    setupcon --keyboard-only 2>&1 | grep "keyboard configuration success"
    CHECK_RESULT $? 0 0 "Failed option:  -k, --keyboard-only"
      
    setupcon -f 2>&1 | grep "font configuration success"
    setupcon --font-only 2>&1 | grep "font configuration success"
    CHECK_RESULT $? 0 0 "Failed option:  -f, --font-only "
      
   setupcon -t 2>&1 | grep "success"
   setupcon --terminal-only 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  -t,--terminal-only"
   setupcon --current-tty 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  --current-tty"
   setupcon --force 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  --force"
   
   LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"