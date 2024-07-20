#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199611@126.com
# @Date      :   2023/10/12
# @Desc      :   user identity authentication sm test
# ##################################
# shellcheck disable=SC2002,SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    which luseradd
}

function run_test() {
    LOG_INFO "Start to run test."
    sed -i 's/sha512/sm3/g' /etc/pam.d/password-auth
    sed -i 's/sha512/sm3/g' /etc/pam.d/system-auth
    useradd testuser
    echo "Huawei12#$
Huawei12#$
" | passwd testuser
    cat /etc/shadow | grep testuser | grep sm3
    CHECK_RESULT $? 0 0 "passwd sm3 test failed"
    userdel -rf testuser
    sed -i 's/sm3/sha512/g' /etc/pam.d/system-auth
    sed -i 's/sm3/sha512/g' /etc/pam.d/password-auth

    groupadd testGroup
    useradd testuser
    echo testuser:testPassword |chpasswd -c SM3
    cat /etc/shadow | grep testuser | grep sm3
    echo testGroup:testPassword |chgpasswd -c SM3
    CHECK_RESULT $? 0 0 "chpasswd sm3 test failed"
    cat /etc/gshadow | grep testGroup | grep sm3
    CHECK_RESULT $? 0 0 "chgpasswd sm3 test failed"
    groupdel testGroup
    userdel -rf testuser

    sed -i 's/yescrypt/sm3/g' /etc/libuser.conf
    luseradd  testuser -P Test@123
    cat /etc/shadow | grep testuser | grep sm3
    CHECK_RESULT $? 0 0 "luseradd sm3 test failed"
    sed -i 's/sm3/yescrypt/g' /etc/libuser.conf
    userdel -rf testuser
    LOG_INFO "End of the test."
}

function post_test() {
    return 0
}

main "$@"


