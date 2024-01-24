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
# @Desc      :   Test etmemd reliability function
# #############################################

source "../etmem_common/common_function.sh"

function pre_test() {
    LOG_INFO "config_etmem_env"
    config_etmem_env
}

function run_test() {
    for((cyc = 0; cyc < 10; cyc++)); do
        # pull up etmemd service
        get_up_service
        wait_fun_start etmemd 1
        CHECK_RESULT $? 0 0 "pull up etmemd service"

        # pull up much etmemd process
        for ((i = 0; i < 100; i++)); do
            get_up_etmemd test_socket_"${i}" 0
        done

        # check etmemd numbers
        wait_fun_start etmemd 101
        CHECK_RESULT $? 0 0 "pull up 101 etmemd process"

        # run killall
        killall etmemd
    done
}

function post_test() {
    # clean env
    LOG_INFO "cleanup etmem test env"
}
main "$@"
