#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2023/08/01
# @License   :   Mulan PSL v2
# @Desc      :   Service update testing 
# #############################################
# shellcheck disable=SC1091
# shellcheck disable=SC2034
source "common/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="360m"
    package_install
    search_all_services 
    select_services
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."    
    if [ -s ./new_service ]; then
        while read -r service; do
            LOG_INFO "Start testing ${service}"
            check_new_service "${service}"
            LOG_INFO "End testing ${service}"
        done < ./new_service 
    else
        LOG_INFO "No service with unadapted cases"
    fi

    if [ -s ./adapted_service ]; then
        test_adapted_service
        grep "oe_test" "${OET_PATH}"/failed_case
        CHECK_RESULT $? 1 0 "Adapted testcase execution failed"        
    else
        LOG_INFO "No service with adapted cases"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_up_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
