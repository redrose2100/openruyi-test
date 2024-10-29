#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# shellcheck disable=SC2034
# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   单文件并发测试
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

testfile=file"$RANDOM"
path=$(pwd)/"$testfile"

function pre_test() {
    which filecap || DNF_INSTALL "libcap-ng libcap-ng-utils"
    touch "$testfile"
}

function run_test() {
    for i in $(seq 10000); do
        {
            filecap "$path" sys_time
            filecap "$path" none
        } &
    done
    wait

    filecap "$path" sys_time
    CHECK_RESULT $? 0 0
    filecap "$path" | grep "sys\_time"
    CHECK_RESULT $? 0 0
}

function post_test() {
    rm -rf "$testfile"
    DNF_REMOVE "$@"
}

main "$@"
