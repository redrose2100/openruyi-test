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
# @Date      :   2023.04.07
# @License   :   Mulan PSL v2
# @Desc      :   File system common command popd
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    mkdir /home/test1 
    mkdir /home/test2
    CHECK_RESULT $? 0 0 "create fail"
    cd /home/test2
    pushd /home/test1
    CHECK_RESULT $? 0 0 "Failed to pushd the dirs"
    dirs | grep test1
    CHECK_RESULT $? 0 0 "Failed to find the dirs" 
    dirs | grep test2
    CHECK_RESULT $? 0 0 "Failed to find the dirs"
    popd
    dirs | grep test1
    CHECK_RESULT $? 0 1 "Command executed successfully"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /home/test1 /home/test2
    LOG_INFO "End to restore the test environment."
}
main $@

