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
# @Desc      :   test psnup
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL psutils
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # test psnup
    psnup -d2 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages"
    CHECK_RESULT $? 0 0 "psnup -d ./common/a4-1.ps execution failed."
    psnup -pA4 -Pletter ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages"
    CHECK_RESULT $? 0 0 "psnup -pA4 -Pletter ./common/a4-1.ps execution failed."
    psnup -w100 -h200 -W50 -H100 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages"
    CHECK_RESULT $? 0 0 "psnup -w100 -h200 -W50 -H100 ./common/a4-1.ps execution failed."
    psnup -q ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages"
    CHECK_RESULT $? 1 0 "psselect -r -q ./common/a4-11.ps execution failed."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
