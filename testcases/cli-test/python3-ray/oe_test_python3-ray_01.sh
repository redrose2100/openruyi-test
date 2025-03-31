#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   yaolijun
#@Contact       :   qinglangy@139.com
#@Date          :   2025-3-27
#@License       :   Mulan PSL v2
#@Desc          :   test ray start
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "python3-ray"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing ray start..."
    ray start --head --port=6379
    CHECK_RESULT $? 0 0 "ray start fail"
    ray status
    CHECK_RESULT $? 0 0 "ray status fail"
    LOG_INFO "Finish ray start test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    ray stop
    DNF_REMOVE "$@" 

    LOG_INFO "End to restore the test environment."
}

main "$@"
