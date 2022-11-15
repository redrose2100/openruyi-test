#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2022-11-15
# @License   :   Mulan PSL v2
# @Desc      :   Command groupmod
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    useradd groupA
    CHECK_RESULT $?
    cat /etc/group |grep -w groupA
    CHECK_RESULT $? 0 0 "groupA is not existent "
    groupmod -g 2222 groupA 
    cat /etc/group |grep -w 2222
    CHECK_RESULT $? 0 0 "groupA id error "
    groupmod -n groupB groupA
    cat /etc/group |grep -w groupB
    CHECK_RESULT $? 0 0 "groupB is not existent "
    userdel -rf groupA
    cat /etc/group |grep -w groupB
    CHECK_RESULT $? 0 0 "groupB is delete "
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"