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
#@Author    	:   gongmenglin
#@Contact   	:   3513202070@qq.com
#@Date      	:   2025-11-25 15:08:23
#@License   	:   Mulan PSL v2
#@Desc      	:   Take Ubturbo Install and Service Control
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ${OET_PATH}/testcases/feature-test/ubs-core/ubturbo/common/ubturbo_common.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    INSTALL_UBTURBO

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    START_UBTURBO_SERVICE

    STOP_UBTURBO_SERVICE

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    REMOVE_UBTURBO

    LOG_INFO "End to restore the test environment."
}

main "$@"
