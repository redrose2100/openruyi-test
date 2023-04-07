#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.4.7
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-atune-profile
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    deploy_autund
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    for ((i=0;i<${#ARRAY_PROFILE[@]};i++));do
        atune-adm profile ${ARRAY_PROFILE[i]} >& temp.log
        CHECK_RESULT $? 0 0 "atune-adm profile failure"
        grep -i "load profile ${ARRAY_PROFILE[i]} Faild" temp.log
        CHECK_RESULT $? 0 1 "load profile exist"
        atune-adm list > temp.log
        grep ${ARRAY_PROFILE[i]} temp.log | grep true
        CHECK_RESULT $? 0 0 "ARRAY_PROFILE not found"
    done
    atune-adm profile -h > temp.log
    grep "active the specified profile and check the actived profile" temp.log
    CHECK_RESULT $? 0 0 "active the specified profile not found"
    array=("$SPECIAL_CHARACTERS" "$ULTRA_LONG_CHARACTERS")
    for ((i=0;i<${#array[@]};i++));do
        atune-adm profile ${array[i]} >& temp.log
        CHECK_RESULT $? 0 1 "atune-adm profile success"
        grep "load profile .* Faild" temp.log
        CHECK_RESULT $? 0 0 "load profile not found"
    done
    atune-adm profile >& temp.log
    grep "only one workloadload type can be set" temp.log
    CHECK_RESULT $? 0 0 "only one workloadload type can be set not found"
}

function post_test() {
    clean_autund
    rm -fr temp.log
}

main $@

