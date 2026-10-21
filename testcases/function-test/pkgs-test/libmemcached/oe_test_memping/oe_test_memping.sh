#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2020/10/27
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of memping command
# ############################################
# shellcheck disable=SC2119
source "${OET_PATH}/testcases/function-test/pkgs-test/libmemcached/common/common_libmemcached.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "Finish preparing the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    memping --help | grep "-"
    CHECK_RESULT $?
    memping --version | grep "memping"
    CHECK_RESULT $?
    memping --verbose --servers=127.0.0.1
    CHECK_RESULT $?
    memcached -d -u root -m 512 -p 11211
    CHECK_RESULT $?
    memping --quiet --servers=127.0.0.1
    CHECK_RESULT $?
    memping --debug --servers=127.0.0.1 2>&1 | grep "Trying to"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
