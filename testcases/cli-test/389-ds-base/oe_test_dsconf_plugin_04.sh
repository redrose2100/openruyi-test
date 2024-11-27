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
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export NSSLAPD_DB_LIB=bdb
    dscreate create-template instance.inf
    dscreate from-file instance.inf
    dsconf -D "cn=Directory Manager" localhost backend create --create-entries --suffix="dc=example,dc=com" --be-name="example"
    dsconf localhost replication enable --suffix "dc=example,dc=com" --role hub --replica-id 1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost plugin pam-pass-through-auth -h | grep "dsconf.*instance.*plugin pam-pass-through-auth"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth -h No Pass"
    dsconf localhost plugin pam-pass-through-auth show -h | grep "usage: dsconf.*instance.*plugin pam-pass-through-auth show"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin  pam-pass-through-auth show -h No Pass"
    dsconf localhost plugin pam-pass-through-auth show | grep "PAM Pass Through Auth"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth show No Pass"
    dsconf localhost plugin pam-pass-through-auth enable -h | grep "usage: dsconf.*instance.*plugin pam-pass-through-auth enable"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth enable -h No Pass"
    dsconf localhost plugin pam-pass-through-auth enable | grep "Enabled plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth enable No Pass"
    dsconf localhost plugin pam-pass-through-auth disable -h | grep "usage: dsconf.*instance.*plugin pam-pass-through-auth disable"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth disable -h No Pass"
    dsconf localhost plugin pam-pass-through-auth disable | grep "Disabled plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth disable No Pass"
    dsconf localhost plugin pam-pass-through-auth status -h | grep "usage: dsconf.*instance.*plugin pam-pass-through-auth status"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth status -h No Pass"
    dsconf localhost plugin  pam-pass-through-auth status | grep "is disabled"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin  pam-pass-through-auth status No Pass"
    dsconf localhost plugin pam-pass-through-auth list -h | grep "usage: dsconf.*instance.*plugin pam-pass-through-auth list"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth list -h No Pass"
    dsconf localhost plugin pam-pass-through-auth config -h | grep "usage: dsconf.*instance.*plugin pam-pass-through-auth config"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth config -h No Pass"
    dsconf localhost plugin pam-pass-through-auth config 123 add | grep "Successfully created"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth config No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"