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

    
    ckbcomp -compact ./common/symbolstest 2>&1 | grep "keymaps 0-4,6,8,10,12,14"
    CHECK_RESULT $? 0 0 "Check ckbcomp: -compact failed"
    
    ckbcomp -freebsd ./common/symbolstest | grep " 001   esc    esc    esc    esc    esc    esc    debug  debug   O"
    CHECK_RESULT $? 0 0 "Check ckbcomp: -freebsd failed"
    
    ckbcomp -backspace bs ./common/symbolstest 2>&1 | grep "keycode 54 = Shift"
    CHECK_RESULT $? 0 0 "Check ckbcomp: -backspace failed"

    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"