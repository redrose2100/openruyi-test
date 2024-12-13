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

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    lang=$(echo $LANG)
    LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    authselect select minimal --force
    CHECK_RESULT $? 0 0 "Backup failure"
    back_up=$(authselect backup-list |awk -F " " 'END{print $1}')
    authselect check |grep "Current configuration is valid"
    CHECK_RESULT $? 0 0 "Validity failure"
    authselect backup-restore $back_up
    CHECK_RESULT $? 0 0 "Recovery failure"
    authselect backup-remove $back_up
    CHECK_RESULT $? 0 0 "remove failure"
    authselect backup-list |grep $back_up
    CHECK_RESULT $? 0 1 "delete failure"
}

function post_test() {
    LANG=$lang
}

main $@

