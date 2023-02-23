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

    
    ckbcomp -compact ./common/symbolstest 2>&1 | grep "keycode 101"
    CHECK_RESULT $? 0 0 "Failed option: -compact"
    
    ckbcomp -freebsd ./common/symbolstest | grep "#"
    CHECK_RESULT $? 0 0 "Failed option: -freebsd"
    
    ckbcomp -backspace bs ./common/symbolstest 2>&1 | grep "Next Scroll_Forward"
    CHECK_RESULT $? 0 0 "Failed option: -backspace"

    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"