#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-6-28
# @License   :   Mulan PSL v2
# @Desc      :   secret-tool of libsecret basic function
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
# shellcheck disable=SC2028

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "dbus-x11 gnome-keyring libsecret"
    export "$(dbus-launch)"
    eval "$(echo '\n' | gnome-keyring-daemon --unlock)"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    expect <<EOF
    spawn /usr/bin/secret-tool store --label 'My special login' my-login test
    expect "*assword:" { send "123\\r" }
    expect eof
EOF
    CHECK_RESULT $? 0 0 "store secret fail"
    /usr/bin/secret-tool lookup my-login test | grep 123
    CHECK_RESULT $? 0 0 "lookup secret fail"
    /usr/bin/secret-tool search my-login test | grep "secret = 123"
    CHECK_RESULT $? 0 0 "search secret fail"
    /usr/bin/secret-tool clear  my-login test
    /usr/bin/secret-tool lookup my-login test
    CHECK_RESULT $? 0 1 "secret clear fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"
