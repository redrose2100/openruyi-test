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
# @Contact   :   yezhifen@uniontech.com		wangxiaorou@uniontech.com
# @Date      :   2023-1-12		2023-4-24
# @License   :   Mulan PSL v2
# @Desc      :   Command chage
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cur_lang=$LANG
    cur_lc_all=$LC_ALL
    export LANG=en_US.UTF-8
    id normal && userdel -rf normal
    useradd normal;echo normal:deepin12#$ | chpasswd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    chage -d 0 normal 
    chage -l normal | grep "password must be changed"
    CHECK_RESULT $? 0 0 "force password expire fail"
    chage -m 5 normal
    chage -l normal | grep "Minimum number of days" | grep 5
    CHECK_RESULT $? 0 0 "modify the days between two password changes fail"
    chage -M 45 normal
    chage -l normal | grep "Maximum number of days" | grep 45
    CHECK_RESULT $? 0 0 "modify password validity fail"
    chage -W 3 normal
    chage -l normal | grep "before password expires" | grep 3
    CHECK_RESULT $? 0 0 "modify the warning days before password expires fail"

    CHECK_RESULT "$(chage -l normal |grep "Account expires" |awk '{print $NF}')" "never" 0 "account default never expires"
    chage -E 0 normal
    CHECK_RESULT "$(chage -l normal |grep "Account expires" |awk -F ":" '{print $NF}')" " Jan 01, 1970" 0 "account expires after modify"
    CHECK_RESULT "$(chage -l -i normal |grep "Account expires" |awk '{print $NF}')" "1970-01-01" 0 "account expires use YYYY-MM-DD when printing dates"

    echo normal:deepin12#$ | chpasswd
    CHECK_RESULT "$(chage -l normal |grep "Password inactive" |awk '{print $NF}')" "never" 0 "default EXPIRE_DATE"
    chage -I 0 normal
    CHECK_RESULT "$(chage -l normal |grep "Password inactive" |awk '{print $NF}')" "$(chage -l normal |grep "Password expires" |awk '{print $NF}')" 0 "set account expiration date to EXPIRE_DATE"

    chage -h |grep -i Usage
    CHECK_RESULT $? 0 0 "help info check"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf normal
    export LANG=$cur_lang
    export LC_ALL=$cur_lc_all
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

