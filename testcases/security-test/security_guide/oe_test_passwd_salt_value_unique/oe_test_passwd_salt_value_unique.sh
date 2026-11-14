#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangxiaorou
#@Contact   	:   wangxiaorou@uniontech.com
#@Date      	:   2022-08-11
#@License   	:   Mulan PSL v2
#@Desc      	:   Check password salt value unique
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    id normal && userdel -rf normal
    useradd normal
    echo "${NODE1_PASSWORD}" |passwd normal --stdin
    LOG_INFO "End to prepare the test environment."
}

# 取 shadow 口令字段里的 salt。
# yescrypt 格式为 $y$<参数如 j9T>$<salt>$<hash>，salt 落在第 4 段；
# 传统 $1$/$5$/$6$ 与 $2b$ 格式为 $id$<salt>$<hash>，salt 落在第 3 段。
# 老脚本一律取第 3 段，遇到 yescrypt 时拿到的是代价参数(如 j9T)而不是
# salt，于是会把“参数相同”误判成“salt 重复”。
function get_salt() {
    getent shadow "$1" | cut -d: -f2 | awk -F'$' '{ if ($2 == "y") print $4; else print $3 }'
}

function run_test() {
    LOG_INFO "Start to run test."
    salt_root_1=$(get_salt root)
    salt_normal_1=$(get_salt normal)
    CHECK_RESULT "${salt_root_1}"  "${salt_normal_1}"  1 "salt value check failed"

    echo "${NODE1_PASSWORD}" |passwd root --stdin
    echo "${NODE1_PASSWORD}" |passwd normal --stdin
    salt_root_2=$(get_salt root)
    salt_normal_2=$(get_salt normal)
    CHECK_RESULT "${salt_root_2}"  "${salt_normal_2}"  1 "salt value check failed"
    CHECK_RESULT "${salt_root_2}"  "${salt_root_1}"  1 "salt value check failed"
    CHECK_RESULT "${salt_normal_2}"  "${salt_normal_1}"  1 "salt value check failed"

    NEW_PWD="openeuler12#$"
    echo "${NEW_PWD}" |passwd root --stdin
    echo "${NEW_PWD}" |passwd normal --stdin
    salt_root_3=$(get_salt root)
    salt_normal_3=$(get_salt normal)
    CHECK_RESULT "${salt_root_3}"  "${salt_normal_3}"  1 "salt value check failed"
    CHECK_RESULT "${salt_root_3}"  "${salt_root_2}"  1 "salt value check failed"
    CHECK_RESULT "${salt_normal_3}"  "${salt_normal_2}"  1 "salt value check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    userdel -rf normal
    echo "${NODE1_PASSWORD}" |passwd root --stdin
    LOG_INFO "End to restore the test environment."
}

main "$@"

