#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2024/02.01
# @License   :   Mulan PSL v2
# @Desc      :   File system common command python3-singledispatch
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-singledispatch.noarch"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    python3 test_python3-singledispatch.py |grep "handling int:42" 
    CHECK_RESULT $? 0 0 "test int type fail"
    python3 test_python3-singledispatch.py |grep "handling str:hello"
    CHECK_RESULT $? 0 0 "test str type fail"
    python3 test_python3-singledispatch.py |grep "handling list:\\[1, 2, 3\\]"
    CHECK_RESULT $? 0 0 "test list type fail"
    python3 test_python3-singledispatch.py |grep "default implementation:(1, 2, 3)"
    CHECK_RESULT $? 0 0 "test tuple type fail"
    
}
function post_test() {
    DNF_REMOVE "$@"
}

main "$@"
