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
# @Author    :   shidongdong
# @Contact   :   1220713556@qq.com
# @Date      :   2023/02/01
# @License   :   Mulan PSL v2
# @Desc      :   Test etmemd param function
# #############################################

source "../etmem_common/common_function.sh"

function pre_test() {
    LOG_INFO "config_etmem_env"
    config_etmem_env
}

function run_test() {
    # pull up an etmemd process
    /usr/bin/etmemd -l 0 &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 1 "check default socket param"

    /usr/bin/etmemd -l 0 -s "" &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 1 "check socket param error"

    /usr/bin/etmemd -l 0 -s "((" &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 0 "check socket param (("
    killall etmemd

    /usr/bin/etmemd -l 0 -s "12++" &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 0 "check socket param ++"
    killall etmemd

    /usr/bin/etmemd -l -1 -s test_socket &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 1 "check level param -1"

    /usr/bin/etmemd -l 0 -s test_socket &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 0 "check level param 0"
    killall etmemd

    /usr/bin/etmemd -l 3 -s test_socket &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 0 "check level param 3"
    killall etmemd

    /usr/bin/etmemd -l 4 -s test_socket &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 1 "check level param 4"

    /usr/bin/etmemd -l 65536 -s test_socket &
    wait_fun_start etmemd
    CHECK_RESULT $? 0 1 "check level param 65536"
}

function post_test() {
    # clean env
    LOG_INFO "cleanup etmem test env"
}
main "$@"
