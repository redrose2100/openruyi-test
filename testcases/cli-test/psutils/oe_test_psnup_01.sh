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
    version=$(rpm -qa psutils | awk -F "-" '{print$2}')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # test psnup
    test "$(psnup --version 2>&1| grep -i "psnup [[:digit:]]" | awk '{print$2}')" == "$version"
    CHECK_RESULT $? 0 0 "psnup -v execution failed."
    psnup -2 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes" # -nup 2 page per sheet
    CHECK_RESULT $? 0 0 "psnup -2 ./common/a4-1.ps  execution failed."
    psnup -4 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -4 ./common/a4-1.ps execution failed."
    psnup -q ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 1 "psnup -q ./common/a4-1.ps execution failed."
    psnup -l ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -l ./common/a4-1.ps execution failed."
    psnup -r ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -r ./common/a4-1.ps execution failed."
    psnup -f ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -f ./common/a4-1.ps execution failed."
    psnup -c ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -c ./common/a4-1.ps execution failed."
    psnup -m42 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -m42 ./common/a4-1.ps execution failed."
    psnup -b20 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 0 "psnup -b20 ./common/a4-1.ps execution failed."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
