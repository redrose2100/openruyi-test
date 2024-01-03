#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   limeiting
#@Contact       :   244349477@qq.com
#@Date      	:   2023-02-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Access of start service
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    useradd test_user_normal
    echo 'normal' | passwd --stdin test_user_normal

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    systemctl start pkgship
    CHECK_RESULT $? 0 0 "Start systemctl pkgship by root failed."
    systemctl stop pkgship
    CHECK_RESULT $? 0 0 "Stop systemctl pkgship by root failed."

    pkgshipd start | grep "\[ERROR\] current user is not pkgshipuser,Please switch user to pkgshipuser"
    CHECK_RESULT $? 0 0 "Start pkgshipd by root unexpectly."
    pkgshipd stop | grep "\[ERROR\] current user is not pkgshipuser,Please switch user to pkgshipuser"
    CHECK_RESULT $? 0 0 "Stop pkgshipd by root unexpectly."

    su test_user_normal -c "pkgshipd start | grep '\[ERROR\] current user is not pkgshipuser,Please switch user to pkgshipuser'"
    CHECK_RESULT $? 0 0 "Start pkgshipd by normal user unexpectly."
    su test_user_normal -c "pkgshipd stop | grep '\[ERROR\] current user is not pkgshipuser,Please switch user to pkgshipuser'"
    CHECK_RESULT $? 0 0 "Stop pkgshipd by normal user unexpectly."

    su pkgshipuser -c "pkgshipd start"
    CHECK_RESULT $? 0 0 "Start pkgshipd by admin failed."
    su pkgshipuser -c "pkgshipd stop | grep 'STOP uwsgi service'"
    CHECK_RESULT $? 0 0 "Stop pkgshipd by admin failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    userdel test_user_normal
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
