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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-7-31
# @License   :   Mulan PSL v2
# @Desc      :   command lsscsi
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL lsscsi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    lsscsi -g 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show SCSI universal device file names fail"
    lsscsi -k 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show kernel name fail"
    lsscsi -d 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show the primary and secondary numbers of device fail"
    lsscsi -H 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show the SCSI host currently connected to the system fail"
    lsscsi -l 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show the additional information for each SCSI device fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/error.log
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
