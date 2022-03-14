#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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

function pre_test() {
    LOG_INFO "Start environmental preparation."
    source ./vtc.env
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOF_INFO "Start to run test"
    bash ./run-regtests.sh ./reg-tests/log/
    CHECK_RESULT $?
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Finish test!"
}

main "$@"
