#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   Jingxu Li
# @Contact   :   jingxu@isrc.iscas.ac.cn
# @Date      :   2022/03/14
# @License   :   Mulan PSL v2
# @Desc      :   Test haproxy
# #############################################

source "../common/common_lib.sh"
source "./common/lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    LOG_INFO "Nothing to do"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOF_INFO "Start to run test"
    bash ./run-regtests.sh ./reg-tests/stick-table/
    CHECK_RESULT $? 0 0 "failed to run stick-table"
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $OET_PATH/testcases/cli-test/haproxy/haproxy/ run-regtests.sh 
    rm -rf /tmp/Vtest/
    rm -rf reg-tests/
    LOG_INFO "Finish test!"
}

main "$@"
