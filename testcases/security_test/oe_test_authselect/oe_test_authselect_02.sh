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
# @Date      :   2023.3.31
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-authselect
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL authselect
    lang="$LANG"
    LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    authselect list |grep minimal
    CHECK_RESULT $? 0 0 "Display failure"
    authselect create-profile test |grep "New profile was created"
    CHECK_RESULT $? 0 0 "Failed to create an empty configuration set. Procedure"
    authselect list
    CHECK_RESULT $? 0 1 "Configuration set display failed"
    rm -fr /etc/authselect/custom
    authselect create-profile test --base-on=minimal |grep "New profile was created"
    CHECK_RESULT $? 0 0 "Failed to create a configuration set. Procedure"
    authselect list |grep minimal
    CHECK_RESULT $? 0 0 "Creation failure"
    authselect requirements custom/test |grep "No requirements are specified"
    CHECK_RESULT $? 0 0 "Failed to print configuration set dependency"
    authselect list-features custom/test |grep with-altfiles
    CHECK_RESULT $? 0 0 "Description Failed to display the configuration set information"
    authselect select custom/test --force |grep 'Profile "custom/test" was selected'
    CHECK_RESULT $? 0 0 "Failed to select a configuration item. Procedure"
    authselect current |grep "Profile ID"
    CHECK_RESULT $? 0 0 "Identifier display failed"
}

function post_test() {
    LANG=$lang
    rm -fr /etc/authselect/custom
    back_up=$(authselect backup-list |awk -F " " 'END{print $1}')
    authselect backup-restore "$back_up"
    authselect backup-remove "$back_up"
    DNF_REMOVE "$@"
}

main "$@"

