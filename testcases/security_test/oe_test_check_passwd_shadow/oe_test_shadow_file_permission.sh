#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lanyanling
# @Contact   :   lanyanling@uniontech.com
# @Date      :   2024-5-24
# @License   :   Mulan PSL v2
# @Desc      :   check shadow file's acl permission
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    grep "^Permission:" /etc/passwd && userdel -rf Permission
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    useradd Permission
    passwd Permission <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    su - Permission -c 'export LANG=en_US.UTF-8;chown -R Permission /etc/shadow' | grep "Operation not permitted"
    CHECK_RESULT $? 0 1 "Can change /etc/shadow file's owner to Permission user."
    su - Permission -c 'export LANG=en_US.UTF-8;ln -s /etc/shadow /home/Permission/shadow-link'
    CHECK_RESULT $? 0 0 "Failed to create /etc/shadow link file."
    su - Permission -c 'export LANG=en_US.UTF-8;cat /home/Permission/shadow-link' | grep "Permission denied"
    CHECK_RESULT $? 0 1 "Can read /etc/shadow link file."
    su - Permission -c 'export LANG=en_US.UTF-8;ln /etc/shadow /etc/shadow-hardlink' | grep "Operation not permitted"
    CHECK_RESULT $? 0 1 "Can create /etc/shadow hard link file."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    userdel -rf Permission
    rm -rf /home/Permission/shadow-link
    LOG_INFO "End to restore the test environment."
}
main "$@"
