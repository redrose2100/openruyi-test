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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/04/17
# @License   :   Mulan PSL v2
# @Desc      :   Test 内核参数vm.swappiness设置
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    sysctl vm.swappiness |grep 30
    CHECK_RESULT $? 0 0 "Failed to detect default parameters"
    sysctl -w vm.swappiness=60
    CHECK_RESULT $? 0 0 "set parameters failed"
    sysctl vm.swappiness |grep 60
    CHECK_RESULT $? 0 0 "Failed to detect parameters"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    sysctl -w vm.swappiness=30
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"