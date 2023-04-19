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
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023.04.14
# @License   :   Mulan PSL v2
# @Desc      :   File system common command locate
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL 'mlocate'
    mkdir /home/new
    touch /home/new/locate_test1
    touch /home/new/locate_test1
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    locate /home/new/locate_test
    CHECK_RESULT $? 0 1 "Command executed error" 
    updatedb
    locate locate_test | grep locate_test1
    CHECK_RESULT $? 0 0 "Failed to locate the files"
    locate locate_test | grep locate_test2
    CHECK_RESULT $? 0 0 "Failed to locate the files"
    locate -n 1 locate_test | grep locate_test2    
    CHECK_RESULT $? 0 1 "Command executed error"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /home/new
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}
main $@

