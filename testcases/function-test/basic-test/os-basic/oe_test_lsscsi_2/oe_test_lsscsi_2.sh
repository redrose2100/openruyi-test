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
# @Date      :   2023-8-1
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
    lsscsi -c 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show scsi device fail"
    lsscsi -p 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show additional Data integrity information fail"
    lsscsi -t 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show transmitted information fail"
    lsscsi -L 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show additional information fail"
    lsscsi -s 2>/tmp/error.log
    test "$(wc -l < /tmp/error.log)" -eq 0
    CHECK_RESULT $? 0 0 "show capacity size fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/error.log
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
