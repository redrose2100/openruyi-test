#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Jevons
#@Contact   	:   1557927445@qq.com
#@Date      	:   2021-05-19 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Only root can specify a user name
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    echo "huawei666" | passwd --stdin test
    CHECK_RESULT $? 0 0 "set failed"
    # 不同 passwd 版本对普通用户改他人密码的提示语不一致：
    # openEuler 为 "Only root can specify a user name"，openRuyi 直接只打印
    # "Current password: " 后因 EOF 失败。断言应只校验“改不动”这一行为。
    su test -c "passwd root" </dev/null >fun294_root_passwd.log 2>&1
    CHECK_RESULT "$(grep -c 'password updated successfully' fun294_root_passwd.log)" 0 0 "change failed"
    su test -c "passwd" << EOF
huawei666
Jevons99$$
Jevons99$$
EOF
    CHECK_RESULT $? 0 0 "change num failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf fun294_root_passwd.log
    userdel -rf test
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
