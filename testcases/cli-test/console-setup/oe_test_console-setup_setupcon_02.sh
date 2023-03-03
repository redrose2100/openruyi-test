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

   setupcon --print-commands-only 2>&1 | grep "setfont '-C' '/dev/tty1' '/usr/share/consolefonts/Uni2-TerminusBold16.psf.gz' "
   CHECK_RESULT $? 0 0 "Check option:  --print-commands-only failed"
   setupcon --save-keyboard 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Check option:  --save-keyboard failed"
   setupcon --setup-dir 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Check setupcon --setup-dir failed"
   setupcon -h 2>&1 | grep "Sets up the font and the keyboard on Linux console."
   CHECK_RESULT $? 0 0 "Check option:  -h failed"
   setupcon --help 2>&1 | grep "Sets up the font and the keyboard on Linux console."
   CHECK_RESULT $? 0 0 "Check option:  --help failed"

   LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"