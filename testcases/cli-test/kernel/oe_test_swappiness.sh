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
# @Author    :   zhangmei
# @Contact   :   zhangmei@uniontech.com
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   Test kernel swappiness set
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    val=$(sysctl vm.swappiness | awk '{print $3}')
    sysctl -w vm.swappiness=60
    CHECK_RESULT $? 0 0 "Failed to vim swappiness"
    res1=$(sysctl -a | grep  vm.swappiness | awk '{print $3}')
    CHECK_RESULT $res1 60 0 "Failed to view swappiness information"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    sysctl -w vm.swappiness=$val
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"