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
# @Author    :   liuyangmei
# @Contact   :   liuyangmei@h-partners.com
# @Date      :   2023/10/16
# @License   :   Mulan PSL v2
# @Desc      :   pav project create创建模板工程
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
project_name=proj"$RANDOM"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    rpm -q secpaver || DNF_INSTALL secpaver
    systemctl is-active pavd || systemctl start pavd
}

# 测试点的执行
function run_test() {
    pav project create "$project_name" .
    CHECK_RESULT $? 0
    ls ./"$project_name"
    CHECK_RESULT $? 0
    pav project create "$project_name" > result1 2>&1
    CHECK_RESULT $? 1
    grep 'Incorrect Usage' result1
    CHECK_RESULT $? 0
    pav project create . > result2 2>&1
    CHECK_RESULT $? 1
    grep 'Incorrect Usage' result2
    CHECK_RESULT $? 0
    pav project create "$project_name" /testpav > result3 2>&1
    CHECK_RESULT $? 1
    cat result3
    grep -E 'directory .*not' result3
    CHECK_RESULT $? 0
}

# 后置处理，恢复测试环境
function post_test() {
    rm -rf result* "$project_name"
    systemctl stop pavd
    DNF_REMOVE "$@"
}

main "$@"
