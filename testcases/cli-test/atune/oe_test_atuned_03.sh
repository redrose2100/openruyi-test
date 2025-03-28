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
# @Date      :   2023.4.3
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-atune
# ############################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_autund
    test_service="test_service"
    test_app="test_app"
    test_scenario="test_scenario"
    profile_path="./common/example.conf"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    atune-adm define -h | grep DESCRIPTION
    CHECK_RESULT $? 0 0 "The help information is displayed incorrectly"
    atune-adm define $test_service $test_app $test_scenario $profile_path >temp.log
    grep "define a new application profile success" temp.log
    CHECK_RESULT $? 0 0 "atune-adm define command execution failure"
    for ((i = 0; i < ${#ARRAY_SERVICE[@]}; i++)); do
        atune-adm define "${ARRAY_SERVICE[i]}" $test_app $test_scenario $profile_path >define.log
        grep "define a new application profile success" define.log
        CHECK_RESULT $? 0 0 "define failure"
        atune-adm undefine "${ARRAY_SERVICE[i]}"-$test_app-$test_scenario >undefine.log
        grep "delete application profile success" undefine.log
        CHECK_RESULT $? 0 0 "undefine failure"
    done
}

function post_test() {
    project=$(atune-adm define "$test_service" "$test_app" "$test_scenario" "$profile_path" | awk -F " " '{print $1}')
    atune-adm undefine "$project"
    clean_autund
    rm -fr temp.log define.log undefine.log
}

main "$@"
