#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2024-4-25
# @License   :   Mulan PSL v2
# @Desc      :   Test unshare
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    num_instances=5
    for ((i=1; i<=num_instances; i++))
    do 
        unshare --mount --fork /bin/bash &
    done
    wait
    CHECK_RESULT $? 0 0 "unshare is failed"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "End to restore the test environment."
}

main "$@"