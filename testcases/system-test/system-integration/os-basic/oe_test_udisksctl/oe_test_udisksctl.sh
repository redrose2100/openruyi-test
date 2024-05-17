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
# @Author    :   ut001707
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-05-17
# @License   :   Mulan PSL v2
# @Desc      :   Command test-cal
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}



function run_test() {
    LOG_INFO "Start to run test."
    udisksctl info |grep -i 'Show information about an object'
    CHECK_RESULT $? 0 1  "check udisksctl inifo failed"
    udisksctl dump status > udisks_status.txt
    CHECK_RESULT $? 0 0  "check udisks_status.txt exist"
    test -e udisks_status.txt
    CHECK_RESULT $? 0 0  "check udisks_status.txt failed"
    udisksctl lock |grep -i 'Lock an encrypted device'
    CHECK_RESULT $? 0 1  "check disksctl lock failed"
    udisksctl unlock |grep -i 'udisksctl unlock'
    CHECK_RESULT $? 0 1  "check udisksctl unlock failed"
    LOG_INFO "End to run test."


}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    LOG_INFO "start environment cleanup!"
    rm -rf file.txt
    LOG_INFO "Finish environment cleanup!"

}

main "$@"







