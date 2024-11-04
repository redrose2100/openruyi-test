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
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "pwdhash" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pwdhash 123456 | grep -E -e "{PBKDF2-SHA512}" -e "{PBKDF2_SHA256}"
    CHECK_RESULT $? 0 0 "L$LINENO: pwdhash No Pass"
    pwdhash -H 123456 | grep -E -e "{PBKDF2-SHA512}" -e "{PBKDF2_SHA256}"
    CHECK_RESULT $? 0 0 "L$LINENO: pwdhash -H No Pass"
    pwdhash -c 123456 123456 | grep -E "password ok"
    CHECK_RESULT $? 0 0 "L$LINENO: pwdhash -c No Pass"
    pwdhash -s md5 123456 | grep -E "{MD5}"
    CHECK_RESULT $? 0 0 "L$LINENO: pwdhash -s No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"