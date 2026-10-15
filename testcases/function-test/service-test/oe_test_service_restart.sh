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

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="360m"
    package_install
    search_all_services 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    while read -r service; do
        _CUR_SVC="${service}"
        _CUR_PKG=$(awk -v s="${service}" '$1==s {print $2}' service_pkg_map 2>/dev/null | head -1)
        LOG_INFO "Start testing ${service} (package: ${_CUR_PKG})"
        check_new_service "${service}"
        LOG_INFO "End testing ${service}"
    done < ./all_services
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_up_env
    print_failure_table
    LOG_INFO "End to restore the test environment."
}

main "$@"
