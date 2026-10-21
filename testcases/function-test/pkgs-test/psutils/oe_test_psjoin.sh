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
# @Desc      :   test psjoin
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL psutils
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # test psjoin
    psjoin -h 2>&1 | grep -i "usage: psjoin"
    CHECK_RESULT $? 0 0 "psjoin -h execution failed."
    psjoin --version 2>&1 | grep -i "psjoin [[:digit:]]"
    CHECK_RESULT $? 0 0 "psjoin -V execution failed."
    psjoin ./common/a4-1.ps ./common/a4-1.ps | grep -i -a "Pages: 2"
    CHECK_RESULT $? 0 0 "psjoin ./common/a4-1.ps ./common/a4-1.ps execution failed."
    psjoin --nostrip psutils.md | grep -i -a "don't strip"
    CHECK_RESULT $? 0 0 "psjoin --strip execution failed."
    psjoin --even ./common/a4-1.ps | grep -a -i -E "pages: [1-9]*[02468]$"
    CHECK_RESULT $? 0 0 "psjoin --even ./common/a4-1.ps execution failed."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
