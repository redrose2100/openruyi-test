#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4-9
# @License   :   Mulan PSL v2
# @Desc      :   Display current configuration information
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL dnf5-plugins
    LOG_INFO "Environmental preparation is over."
}
function run_test() {
    LOG_INFO "Start executing testcase."
    # dnf5 的 config-manager 已删除 --dump，配置信息改由 repoinfo / --help 展示
    dnf config-manager --help | grep -iE "addrepo|setopt"
    CHECK_RESULT $?
    num_id=$(dnf repolist | wc -l)
    test "${num_id}" -gt 1
    CHECK_RESULT $?
    repoid=$(dnf repolist | awk 'NR>1{print $1; exit}')
    test -n "${repoid}"
    CHECK_RESULT $?
    dnf repoinfo "${repoid}" | grep -i "repo-id"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

main $@
