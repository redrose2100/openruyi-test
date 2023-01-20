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
# @Author    :   dingjiao
# @Contact   :   dingjiao666@163.com
# @Date      :   2023/01/20
# @License   :   Mulan PSL v2
# @Desc      :   Check rpm package name
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    package_name=$(uname -a | awk -F ' ' '{print $3}' | awk -F '.' '{print $(NF-1)}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    current_package=$(dnf list | grep -w $package_name| wc -l)
    all_package=$(dnf list | wc -l)
    test $current_package -eq $all_package
    CHECK_RESULT $? 0 0 "Check rpm package name: failed!"
    LOG_INFO "End to run test."
}

main "$@"
