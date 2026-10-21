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
# @Desc      :   test psbook
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

    # test psbook
    test "$(psbook --version 2>&1 | awk 'NR==1{print$2}')" == "$version"
    CHECK_RESULT $? 0 0 "psbook -v execution failed."
    psbook -s4 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages"
    CHECK_RESULT $? 0 0 "psbook -s4 ./common/a4-1.ps execution failed."
    psbook -q -s8 ./common/a4-1.ps 2>&1 | grep -i -a "wrote .* pages, .* bytes"
    CHECK_RESULT $? 0 1 "psbook -q -s8 ./common/a4-1.ps execution failed."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
