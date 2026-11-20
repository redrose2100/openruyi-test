#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   install Software Group
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    yum group remove 'Network Servers' -y
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # 组信息（comps 元数据）是仓库可选项，openRuyi 的 repo 未提供 comps，
    # 因此 yum group list 里不会有 Network Servers，后续 install/remove 全部
    # 报 "No groups to remove"。没有组时用例场景不成立，明确跳过。
    yum group list >yum_group_all 2>&1
    if ! grep -qE 'Available (Environment )?Groups|Installed (Environment )?Groups' yum_group_all; then
        LOG_WARN "The enabled repositories provide no comps groups, skip yum group test."
        LOG_INFO "Finish test!"
        return 0
    fi
    grep 'Network Servers' yum_group_all
    CHECK_RESULT $?
    yum group info 'Network Servers' | grep '   ' >yum_list
    yum group install 'Network Servers' -y
    CHECK_RESULT $?
    while read line; do
        rpm -qa "${line}"
        CHECK_RESULT $?
    done <yum_list
    yum group install 'Network Servers' -y
    CHECK_RESULT $?

    yum group remove 'Network Servers' -y
    CHECK_RESULT $?

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -rf yum_list yum_group_all
    LOG_INFO "Finish environment cleanup!"
}

main $@
