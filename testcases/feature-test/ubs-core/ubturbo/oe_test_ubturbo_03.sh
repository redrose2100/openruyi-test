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
#@Contact   	:   yili@isrc.iscas.ac.cn
#@Date      	:   2025-11-25 15:08:23
#@License   	:   Mulan PSL v2
#@Desc      	:   Test TurboGetFloat APi:Read Config Successfully
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ${OET_PATH}/testcases/feature-test/ubs-core/ubturbo/common/ubturbo_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    INSTALL_UBTURBO
    INIT_UBTURBO_API_ENV
    COMFORM_SYMBOL_PRESENT "TurboGetFloatHandler"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    RUN_UBTURBO_TEST "ubturbo_get_conf_api_call" "float_norm = 3.14159" "TurboGetFloat" "float_norm" "float_norm=3.14159"
    RUN_UBTURBO_TEST "ubturbo_get_conf_api_call" "float_exp = 1e-3" "TurboGetFloat" "float_exp" "float_exp=0.001"
    RUN_UBTURBO_TEST "ubturbo_get_conf_api_call" "float_expp = 2E10" "TurboGetFloat" "float_expp" "float_expp=2e+10"
    RUN_UBTURBO_TEST "ubturbo_get_conf_api_call" "float_neg = -0.5" "TurboGetFloat" "float_neg" "float_neg=-0.5"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DEINIT_UBTURBO_API_ENV
    REMOVE_UBTURBO

    LOG_INFO "End to restore the test environment."
}

main "$@"
