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
# @Author    :   aliceye666	wangxiaorou
# @Contact   :   yezhifen@uniontech.com	wangxiaorou@uniontech.com
# @Date      :   2022-11-15	2023-04-17
# @License   :   Mulan PSL v2
# @Desc      :   Command groupmod
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    id groupA && userdel -rf groupA
    grep -rw groupA /etc/group && groupdel -f groupA
    grep -rw groupB /etc/group && groupdel -f groupB
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    useradd groupA
    CHECK_RESULT $? 0 0 "create user,username is groupA"
    cat /etc/group |grep -w groupA
    CHECK_RESULT $? 0 0 "groupA is not existent "
    groupmod -g 2222 groupA 
    cat /etc/group |grep -w 2222
    CHECK_RESULT $? 0 0 "groupA id error "
    groupmod -n groupB groupA
    cat /etc/group |grep -w groupB
    CHECK_RESULT $? 0 0 "groupB is not existent "
    cat /etc/group |grep -w groupB
    CHECK_RESULT $? 0 0 "groupB is delete "

    groupadd -g 2222 groupA
    CHECK_RESULT $? 0 1 "Add group for gid unique"
    groupadd -o -g 2222 groupA
    CHECK_RESULT $? 0 0 "Add group for gid not unique"
    CHECK_RESULT "$(cat /etc/group |grep groupA |awk -F ":" '{print $3}')" "2222" 0 "check GID of groupA"
    CHECK_RESULT "$(cat /etc/group |grep groupB |awk -F ":" '{print $3}')" "2222" 0 "check GID of groupB"

    cat /etc/group |grep groupA |awk -F ":" '{print $4}' |grep groupA
    CHECK_RESULT $? 0 1 "no user in groupA default"
    groupmod -U groupA -a groupA
    CHECK_RESULT "$(cat /etc/group |grep groupA |awk -F ":" '{print $4}')" "groupA" 0 "check user of groupA"

    CHECK_RESULT "$(cat /etc/gshadow |grep groupA |awk -F ":" '{print $2}')" "!" 0 "no password of groupA default"
    groupmod  -p 'key-string' groupA
    CHECK_RESULT "$(cat /etc/gshadow  |grep groupA |awk -F ":" '{print $2}')" "key-string" 0 "check password of groupA"

    groupmod --help |grep -Ei "用法|Usage"
    CHECK_RESULT $? 0 0 "check usage of groupmod"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    id groupA && userdel -rf groupA
    grep -rw groupA /etc/group && groupdel -f groupA
    grep -rw groupB /etc/group && groupdel -f groupB
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
