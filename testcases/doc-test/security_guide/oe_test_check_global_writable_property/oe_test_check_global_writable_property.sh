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
# @Author    :   yanglijin
# @Contact   :   yang_lijin@qq.com
# @Date      :   2021/7/23
# @License   :   Mulan PSL v2
# @Desc      :   Check global writable property of unauthorized file
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function run_test() {
    LOG_INFO "Start executing testcase."
    find / -type d -perm 1777 | grep -v 'proc'
    CHECK_RESULT $? 0 0 "check global writable directory failed"
    arch=$(uname -m)
    find_result=$(find / -type f \( -perm -o+w \) 2>/dev/null | grep -vE 'proc|cgroup|selinux')
    if [ -n "$find_result" ]; then
        res=0
    else 
        res=1
    fi
    if [ "$arch" == "riscv64" ]; then
        CHECK_RESULT "$res" 0 0 "check global writable file failed"
    elif [ "$arch" == "x86_64" ]; then
        CHECK_RESULT "$res" 0 1 "check global writable file failed"
    fi
    LOG_INFO "Finish testcase execution."
}

function post_test(){
    LOG_INFO "Start cleanning environment."
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
