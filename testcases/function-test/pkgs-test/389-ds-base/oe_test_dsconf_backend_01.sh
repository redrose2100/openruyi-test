#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   tanxin
# @Contact   :   njutanx@163.com
# @Date      :   2023/8/13
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost backend suffix -h | grep "usage: dsconf.*instance.*backend suffix"
    CHECK_RESULT $? 0 0 "Check: backend suffix list No Pass"
    dsconf localhost backend suffix list -h | grep "usage: dsconf.*instance.*backend suffix list"
    CHECK_RESULT $? 0 0 "Check: backend suffix list No Pass"
    dsconf localhost backend suffix list --suffix | grep -E "dc|ou|cn|No backends"
    CHECK_RESULT $? 0 0 "Check: backend suffix list -suffix No Pass"
    dsconf localhost backend suffix list --skip-subsuffixes | grep -E "dc|ou|cn|no backends"
    CHECK_RESULT $? 0 0 "Check: backend suffix list -skip-subsuffixes No Pass"
    dsconf localhost backend suffix get -h | grep "usage: dsconf.*instance.*backend suffix get"
    CHECK_RESULT $? 0 0 "Check: backend suffix get -h No Pass"
    dsconf localhost backend suffix get dc=example,dc=com | grep "cn=example"
    CHECK_RESULT $? 0 0 "Check: backend suffix get selector No Pass"
    dsconf localhost backend suffix get-dn -h | grep "usage: dsconf.*instance.*backend suffix get-dn"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-dn -h No Pass"
    dsconf localhost backend suffix get-dn "cn=example,cn=ldbm database,cn=plugins,cn=config" | grep "cn=example"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-dn dn No Pass"
    dsconf localhost backend suffix get-sub-suffixes -h | grep "usage: dsconf.*instance.*backend suffix get-sub-suffixes"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-sub-suffixes -h No Pass"
    dsconf localhost backend suffix get-sub-suffixes --suffix example | grep "No sub-suffixes under this backend"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-sub-suffixes --suffix No Pass"
    dsconf localhost backend suffix set -h | grep "usage: dsconf.*instance.*backend suffix set"
    CHECK_RESULT $? 0 0 "Check: backend suffix set No Pass"
    dsconf localhost backend suffix set example --enable-readonly | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --enable-readonly No Pass"
    dsconf localhost backend suffix set example --disable-readonly | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --disable-readonly No Pass"
    dsconf localhost backend suffix set example --require-index | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --required-index No Pass"
    dsconf localhost backend suffix set example --ignore-index | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --ignore-index No Pass"
    dsconf localhost backend suffix set example --add-referral ou=eve | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --add-referral No Pass"
    dsconf localhost backend suffix set example --del-referral ou=eve | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --del-referral No Pass"
    dsconf localhost backend suffix set example --enable | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --enable No Pass"
    dsconf localhost backend suffix set example --disable | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --disable No Pass"
    dsconf localhost backend config set --cache-autosize=0
    dsconf localhost backend suffix set example --cache-size 100 | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --cache-size No Pass"
    dsconf localhost backend suffix set example --cache-memsize 100 | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --cache-memsize No Pass"
    dsconf localhost backend suffix set example --dncache-memsize 100 | grep "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --dncache-memsize No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
