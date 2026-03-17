#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-03-14
#@License       :   Mulan PSL v2
#@Desc          :   Test case for grpunconv command
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL shadow-utils
    cp -f /etc/group /etc/group.bak
    if [ -f /etc/gshadow ]; then
        cp -f /etc/gshadow /etc/gshadow.bak
    else
        touch /etc/gshadow.bak.empty
    fi
    groupadd testgrp
    if [ ! -f /etc/gshadow ]; then
        grpconv
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grpunconv -h | grep -q "用法：grpunconv"
    CHECK_RESULT $? 0 0 "Help test failed"
    test -f /etc/gshadow
    CHECK_RESULT $? 0 0 "gshadow missing before test"
    grpunconv
    CHECK_RESULT $? 0 0 "grpunconv execution failed"
    test ! -f /etc/gshadow
    CHECK_RESULT $? 0 0 "gshadow not removed"
    grep "^testgrp:" /etc/group | grep -q ':[!]:'
    CHECK_RESULT $? 0 0 "Group conversion failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    groupdel testgrp >/dev/null 2>&1 || true
    cp -f /etc/group.bak /etc/group
    if [ -f /etc/gshadow.bak ]; then
        cp -f /etc/gshadow.bak /etc/gshadow
    else
        rm -f /etc/gshadow
    fi
    rm -f /etc/group.bak /etc/gshadow.bak /etc/gshadow.bak.empty 2>/dev/null
    LOG_INFO "End to restore the test environment."
}

main "$@"
