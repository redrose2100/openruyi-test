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
# @Date      :   2023.4.4
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-atune_undefine
# ############################################
# shellcheck disable=SC1091,SC2086,SC2254
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/common_lib.sh"

test_service="test_service"
test_app="test_app"
test_scenario="test_scenario"
profile_path="./common/example.conf"
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_autund
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    atune-adm define $test_service $test_app $test_scenario $profile_path
    atune-adm list >temp.log
    grep "$test_service" temp.log | grep "$test_app-$test_scenario"
    CHECK_RESULT $? 0 0 "atune-adm define command execution failed"
    atune-adm undefine $test_service-$test_app-$test_scenario
    atune-adm list >temp.log
    grep "$test_service" temp.log | grep "$test_app-$test_scenario"
    CHECK_RESULT $? 1 0 "atune-adm undefine command execution failed"
    atune-adm undefine -h >temp.log
    grep "delete the specified profile" temp.log
    CHECK_RESULT $? 0 0 "atune-adm undefine -h command execution failed"
    # Check all the supported workload
    for ((i = 0; i < ${#ARRAY_PROFILE[@]}; i++)); do
        atune-adm undefine "${ARRAY_PROFILE[i]}" >&temp.log
        CHECK_RESULT $? 0 0 "undefine command execution failed"
        grep "only self defined type can be deleted" temp.log
        CHECK_RESULT $? 0 0 "delete failed"
    done
    # The input of the workload_type is special character, ultra long character and null
    array=("$SPECIAL_CHARACTERS" "$ULTRA_LONG_CHARACTERS" "")
    for ((i = 0; i < ${#array[@]}; i++)); do
        atune-adm undefine ${array[i]} >&temp.log
        case ${array[i]} in
        "$SPECIAL_CHARACTERS")
            CHECK_RESULT $? 1 0 "The status code is not 1"
            grep "input:.* is invalid" temp.log
            ;;
        $ULTRA_LONG_CHARACTERS)
            CHECK_RESULT $? 0 0 "The status code is not 0"
            grep "only self defined type can be deleted" temp.log
            ;;
        *)
            CHECK_RESULT $? 1 0 "only self defined type can be deleted"
            grep "Incorrect Usage." temp.log
            ;;
        esac
        CHECK_RESULT $? 0 0 "Cyclic failure"
    done
}

function post_test() {
    clean_autund
    rm -fr temp.log
}

main "$@"
