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
# @Desc      	:   the test of ckbcomp package
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "No pkgs need to install."

    LOG_INFO "End to prepare the test environment."
}

function run_test() {

    LOG_INFO "Start to run test."
    ckbcomp  -help 2>&1 | grep "Usage: ckbcomp"
    ckbcomp  -? 2>&1 | grep "Usage: ckbcomp"
    CHECK_RESULT $? 0 0 "Failed option: -?,-help"
    
    ckbcomp  -charmap ARMSCII-8  ./common/symbolstest  2>&1 | grep "keymaps 0-127"
    CHECK_RESULT $? 0 0 "Failed option: -charmap"
   
    ckbcomp ./common/symbolstest -I /usr/  2>&1 | grep "keymaps 0-127"
    CHECK_RESULT $? 0 0 "Failed option: -I"
    
    ckbcomp -keycodes ./common/keycodestest us 2>&1 | grep "keymaps 0-127" 
    CHECK_RESULT $? 0 0 "Failed option: -keycodes"
    
    ckbcomp -symbols ./common/symbolstest  norman 2>&1 | grep "keymaps 0-127"
    CHECK_RESULT $? 0 0 "Failed option: -symbols"
    
    ckbcomp -rules ./base ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -rules"
   
    ckbcomp -model pc105 ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -model"
    
    ckbcomp -layout us ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -layout"
  
    ckbcomp -variant  $ ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -variant"
    
    ckbcomp -option terminate:ctrl_alt_bksp,lv3:ralt_switch,grp:alts_toggle ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -option"
    
    ckbcomp -v 1  ./common/symbolstest | grep "Down" 
    CHECK_RESULT $? 0 0 "Failed option: -v"
    
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"