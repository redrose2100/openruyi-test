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
# @Date      :   2022-12-13
# @License   :   Mulan PSL v2
# @Desc      :   Command useradd
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    useradd -D
    CHECK_RESULT $? 
    useradd -m -s /bin/bash ACE1
    CHECK_RESULT $? 
    useradd ACE2
    CHECK_RESULT $?    	
    useradd -M -s /bin/sh ACE3
    CHECK_RESULT $? 
    useradd -e 2020-8-4 ACE4	
    CHECK_RESULT $? 
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf ACE1
    userdel -rf ACE2
    userdel -f ACE3
    userdel -rf ACE4
    LOG_INFO "Finish environment cleanup!"
}

main "$@"