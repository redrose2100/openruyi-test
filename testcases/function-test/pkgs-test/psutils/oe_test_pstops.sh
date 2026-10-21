#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linjianbo
# @Contact   :   jianbo.lin@outlook.com
# @Date      :   2023/07/28
# @License   :   Mulan PSL v2
# @Desc      :   test pstops and includeres
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL psutils
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # test pstops
    pstops -q '2:0L@.7(21cm,0)+1L@.7(21cm,14.85cm)' ./common/a4-11.ps 2>&1 | grep -a -i "wrote .* pages"
    CHECK_RESULT $? 0 1 "pstops '2:0L@.7(21cm,0)+1L@.7(21cm,14.85cm)' ./common/a4-11.ps execution failed."
    pstops -pA4 '2:-0' ./common/a4-11.ps 2>&1 | grep -a -i "A4"
    CHECK_RESULT $? 0 0 "pstops '2:-0' ./common/a4-11.ps execution failed."
    pstops -b -h11in -w8.5in -d2pt '4:-3L@.7(21cm,0)+0L@.7(21cm,14.85cm)' ./common/a4-11.ps 2>&1 | grep -a -i "wrote .* pages"
    CHECK_RESULT $? 0 0 "pstops '4:-3L@.7(21cm,0)+0L@.7(21cm,14.85cm)' ./common/a4-11.ps execution failed."

    # test includeres
    includeres ./common/a4-1.ps 2>&1 | grep "includeres: resource"
    CHECK_RESULT $? 0 0 "includeres ./common/a4-1.ps execution failed."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
