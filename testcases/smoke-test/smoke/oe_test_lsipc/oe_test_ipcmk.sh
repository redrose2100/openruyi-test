#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025-05-27
# @License   :   Mulan PSL v2
# @Desc      :   test ipcmk
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "util-linux"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    local ipcid
    ipcid=$(LANG="" ipcmk -M 1 | awk '{print $NF}')
    CHECK_RESULT $? 0 0 "ipcmk -M 1 failed"
    lsipc -m | grep "1B"
    CHECK_RESULT $? 0 0 "no specific shm found, ipcmk may failed"
    ipcrm -m "$ipcid"
    CHECK_RESULT $? 0 0 "ipcrm -m ${ipcid} failed"

    ipcid=$(LANG="" ipcmk -S 1 | awk '{print $NF}')
    CHECK_RESULT $? 0 0 "ipcmk -S 1, make semaphore failed."
    lsipc -s | grep "1"
    CHECK_RESULT $? 0 0 "no semaphores found, ipcmk may failed"
    ipcrm -s "$ipcid"
    CHECK_RESULT $? 0 0 "ipcrm -s ${ipcid} failed"

    ipcid=$(LANG="" ipcmk -Q | awk '{print $NF}')
    CHECK_RESULT $? 0 0 "ipcmk -Q failed"
    lsipc -q | grep "$ipcid"
    CHECK_RESULT $? 0 0 "no specific queue found. ipcmk may failed"
    ipcrm -q "$ipcid"
    CHECK_RESULT $? 0 0 "ipcrm -q ${ipcid} failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}


main "$@"
