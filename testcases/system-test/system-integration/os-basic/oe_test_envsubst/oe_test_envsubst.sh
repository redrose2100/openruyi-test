#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-05-15
# @License   :   Mulan PSL v2
# @Desc      :   Command test-envsubst
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo name: $name >envsubst-template.yaml
    echo namespace: $ns >>envsubst-template.yaml   
    CHECK_RESULT $? 0 0 "check create file fail"
    name='hello' ns='world' envsubst < envsubst-template.yaml|grep "name: hello"
    CHECK_RESULT $? 0 0  "Variable replacement failure"
    name='hello' ns='world' envsubst --variables '$name,$ns'< envsubst-template.yaml > envsubst-4.yaml
    CHECK_RESULT $? 0 0  "check command fail"
    cat  envsubst-4.yaml|grep -v hello|grep -w name
    CHECK_RESULT $? 0 0  "Failed to view only variables"
    envsubst -h|grep envsubst
    CHECK_RESULT $? 0 0  "check command fail"
    envsubst -V|grep "GNU gettext-runtime"    
    CHECK_RESULT $? 0 0  "check command fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf envsubst-template.yaml  envsubst-4.yaml
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

