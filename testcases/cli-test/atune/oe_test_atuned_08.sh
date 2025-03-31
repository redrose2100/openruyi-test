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
# @Date      :   2023.4.6
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-atune-rollback
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
    atune-adm rollback
    CHECK_RESULT $? 0 0 "atune-adm rollback failure"
    # There is no activated profile
    atune-adm list >temp.log
    awk -F '|' '{print $4}' temp.log | grep true
    CHECK_RESULT $? 0 1 "atune-adm list failure"
    # Help info
    atune-adm rollback -h >temp.log
    grep "rollback the system config to the init state" temp.log
    CHECK_RESULT $? 0 0 "atune-adm rollback -h failure"
    # Extra input
    atune-adm rollback extra_input >temp.log
    grep "Incorrect Usage." temp.log
    CHECK_RESULT $? 0 0 "Incorrect Usage not found"
}
function post_test() {
    clean_autund
    rm -fr analysis_file temp.log
}

main "$@"
