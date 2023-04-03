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

    DNF_INSTALL console-setup 

    LOG_INFO "End to prepare the test environment."
}

function run_test() {

    LOG_INFO "Start to run test."
    ckbcomp  -help 2>&1 | grep "Usage: ckbcomp"
    CHECK_RESULT $? 0 0 "Check ckbcomp: -? failed"
    ckbcomp  -? 2>&1 | grep "Usage: ckbcomp"
    CHECK_RESULT $? 0 0 "Check ckbcomp: -help failed"
    
    ckbcomp  -charmap ARMSCII-8  ./common/symbolstest  2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -charmap failed"
   
    ckbcomp ./common/symbolstest -I /usr/  2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -I failed"
    
    ckbcomp -keycodes ./common/keycodestest us 2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -keycodes failed"
    
    ckbcomp -symbols ./common/symbolstest  norman 2>&1
    CHECK_RESULT $? 0 0 "Check ckbcomp: -symbols failed"
    
    ckbcomp -rules ./base ./common/symbolstest 2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -rules failed"
   
    ckbcomp -model pc105 ./common/symbolstest 2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -model failed"
    
    ckbcomp -layout us ./common/symbolstest 2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -layout failed"
  
    ckbcomp -variant  $ ./common/symbolstest 2>&1 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -variant failed"
    
    ckbcomp -option terminate:ctrl_alt_bksp,lv3:ralt_switch,grp:alts_toggle ./common/symbolstest 2>&1 | grep "shiftl alt control keycode 14 = Delete"
    CHECK_RESULT $? 0 0 "Check ckbcomp: -option failed"
    
    ckbcomp -v 1  ./common/symbolstest | grep "keycode 119 = Pause" 
    CHECK_RESULT $? 0 0 "Check ckbcomp: -v failed"
    
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"