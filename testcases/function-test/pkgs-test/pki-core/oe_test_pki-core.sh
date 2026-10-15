#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.9.4
# @License   :   Mulan PSL v2
# @Desc      :   pki-tools formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "pki-tools"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep pki-tools
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && touch test1.txt
    AtoB test1.txt test2.txt
    test -f /tmp/test2.txt
    CHECK_RESULT $? 0 0 "compile test1.txt fail"
    BtoA test2.txt test3
    test -f /tmp/test3
    CHECK_RESULT $? 0 0 "execute test2.txt fail"    
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test1.txt  /tmp/test2.txt /tmp/test3
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
