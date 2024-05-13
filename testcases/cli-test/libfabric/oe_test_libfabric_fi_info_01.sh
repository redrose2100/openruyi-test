#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libfabric command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libfabric
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fi_info -h 2>&1 | grep 'Usage: fi_info'
    CHECK_RESULT $? 0 0 "Check fi_info -h failed"
    fi_info --help 2>&1 | grep 'Usage: fi_info'
    CHECK_RESULT $? 0 0 "Check fi_info --help failed"
    fi_info -n 'http://127.0.0.1' 2>&1 | grep 'provider: shm'
    CHECK_RESULT $? 0 0 "Check fi_info -n failed"
    fi_info --node='http://127.0.0.1' 2>&1 | grep 'provider: shm'
    CHECK_RESULT $? 0 0 "Check fi_info --node failed"
    fi_info -P 80 2>&1 | grep 'provider:'
    CHECK_RESULT $? 0 0 "Check fi_info -P failed"
    fi_info --port=80 2>&1 | grep 'provider:'
    CHECK_RESULT $? 0 0 "Check fi_info --port failed"
    fi_info -c'FI_MSG' 2>&1 | grep -i 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info -c failed"
    fi_info --caps='FI_MSG' 2>&1 | grep -i 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info --caps failed"
    fi_info --mode='' 2>&1 | grep -i 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info --mode failed"
    fi_info -m '' 2>&1 | grep -i 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info -m failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
