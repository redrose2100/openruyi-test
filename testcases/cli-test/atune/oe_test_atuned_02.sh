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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    atune-adm list >temp.log
    for ((i = 0; i < ${#ARRAY_SERVICE[@]}; i++)); do
        grep "${ARRAY_SERVICE[i]}" temp.log
        CHECK_RESULT $? 0 0 "atune-adm list command execution failed. Procedure"
    done
    atune-adm list -h >temp.log
    grep "list current support profiles" temp.log
    CHECK_RESULT $? 0 0 "atune-adm list -h command execution failed. Procedure"
    atune-adm list extra_input >temp.log
    grep "Incorrect Usage." temp.log
    CHECK_RESULT $? 0 0 "atune-adm list extra_input command execution failed. Procedure"
}

function post_test() {
    clean_autund
    rm -fr temp.log
}

main "$@"
