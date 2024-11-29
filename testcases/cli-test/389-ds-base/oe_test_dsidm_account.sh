#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test "dsidm" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    cat <<EOF >instance.inf
[general]
config_version = 2

[slapd]
root_password = 12345678

[backend-userroot]
sample_entries = yes
suffix = dc=example,dc=com
EOF
    dscreate from-file instance.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsidm localhost account -h | grep "usage: dsidm.*instance.*account"
    CHECK_RESULT $? 0 0 "L$LINENO: account -h No Pass"
    dsidm localhost account list -h | grep "usage: dsidm.*instance.*account list"
    CHECK_RESULT $? 0 0 "L$LINENO: account list -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account list | grep "dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: account list No Pass"=
    dsidm localhost account get-by-dn -h | grep "usage: dsidm.*instance.*account get-by-dn"
    CHECK_RESULT $? 0 0 "L$LINENO: account get-by-dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account get-by-dn "dc=example,dc=com" | grep "objectClass: domain"
    CHECK_RESULT $? 0 0 "L$LINENO: account get-by-dn No Pass"
    dsidm localhost account modify-by-dn -h | grep "usage: dsidm.*instance.*account modify-by-dn"
    CHECK_RESULT $? 0 0 "L$LINENO: account modify-by-dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account modify-by-dn "uid=demo_user,ou=people,dc=example,dc=com" \
        replace:uidNumber:1000 | grep "Successfully modified uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: account modify-by-dn No Pass"
    dsidm localhost account rename-by-dn -h | grep "usage: dsidm.*instance.*account rename-by-dn"
    CHECK_RESULT $? 0 0 "L$LINENO: account rename-by-dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account rename-by-dn "uid=demo_user,ou=people,dc=example,dc=com" \
        "uid=demo_user,ou=people,dc=example,dc=com" | grep "Successfully renamed to uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: account rename-by-dn No Pass"
    dsidm localhost account unlock -h | grep "usage: dsidm.*instance.*account unlock"
    CHECK_RESULT $? 0 0 "L$LINENO: account unlock -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account unlock "uid=demo_user,ou=people,dc=example,dc=com" |
        grep "Entry uid=demo_user,ou=people,dc=example,dc=com is unlocked"
    CHECK_RESULT $? 0 0 "L$LINENO: account unlock No Pass"
    dsidm localhost account lock -h | grep "usage: dsidm.*instance.*account lock"
    CHECK_RESULT $? 0 0 "L$LINENO: account lock -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account lock "uid=demo_user,ou=people,dc=example,dc=com" |
        grep "Entry uid=demo_user,ou=people,dc=example,dc=com is locked"
    CHECK_RESULT $? 0 0 "L$LINENO: account lock No Pass"
    dsidm localhost account entry-status -h | grep "usage: dsidm.*instance.*account entry-status"
    CHECK_RESULT $? 0 0 "L$LINENO: account entry-status -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account entry-status -V "uid=demo_user,ou=people,dc=example,dc=com" |
        grep "Entry State: directly locked through nsAccountLock"
    CHECK_RESULT $? 0 0 "L$LINENO: account entry-status No Pass"
    dsidm localhost account subtree-status -h | grep "usage: dsidm.*instance.*account subtree-status"
    CHECK_RESULT $? 0 0 "L$LINENO: account subtree-status -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account subtree-status "ou=people,dc=example,dc=com" | grep "Entry DN: ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: account subtree-status No Pass"
    dsidm localhost account reset_password -h | grep "usage: dsidm.*instance.*account reset_password"
    CHECK_RESULT $? 0 0 "L$LINENO: account reset_password -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account reset_password "uid=demo_user,ou=people,dc=example,dc=com" \
        12345678 | grep "reset password for uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: account reset_password No Pass"
    dsidm localhost account change_password -h | grep "usage: dsidm.*instance.*account change_password"
    CHECK_RESULT $? 0 0 "L$LINENO: account change_password -h No Pass"
    dsidm -b "dc=example,dc=com" localhost account change_password "uid=demo_user,ou=people,dc=example,dc=com" \
        1234567 12345678 | grep "changed password for uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: account change_password No Pass"
    dsidm localhost account delete -h | grep "usage: dsidm.*instance.*account delete"
    CHECK_RESULT $? 0 0 "L$LINENO: account delete -h No Pass"
    echo "Yes I am sure" | dsidm -b "dc=example,dc=com" localhost account delete \
        "uid=demo_user,ou=people,dc=example,dc=com" | grep "Successfully deleted uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: user delete No Pass"
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
