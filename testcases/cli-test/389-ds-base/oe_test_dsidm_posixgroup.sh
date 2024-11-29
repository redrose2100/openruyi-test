#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   shang jiwei
#@Contact   :   1065099936@qq.com
#@Date      :   2023/08/07
#@License   :   Mulan PSL v2
#@Desc      :   Test "dsidm" command
###################################

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
    dsidm localhost posixgroup -h | grep "usage: dsidm.*instance.*posixgroup"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup -h No Pass"
    dsidm localhost posixgroup list -h | grep "usage: dsidm.*instance.*posixgroup list"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup list -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup list | grep "demo_group"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup list No Pass"
    dsidm localhost posixgroup get -h | grep "usage: dsidm.*instance.*posixgroup get"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup get "demo_group" | grep "cn: demo_group"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get No Pass"
    dsidm localhost posixgroup get_dn -h | grep "usage: dsidm.*instance.*posixgroup get_dn"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get_dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup get_dn "cn=demo_group,ou=groups,dc=example,dc=com" |
        grep "demo_group"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get_dn No Pass"
    dsidm localhost posixgroup create -h | grep "usage: dsidm.*instance.*posixgroup create"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup create -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup create --cn demo_posix --gidNumber 10000 | grep "Successfully created demo_posix"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup create No Pass"
    dsidm localhost posixgroup modify -h | grep "usage: dsidm.*instance.*posixgroup modify"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup modify -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup modify demo_posix replace:cn:demo_posix |
        grep -i "Successfully modified cn=demo_posix,ou=groups,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup modify No Pass"
    dsidm localhost posixgroup rename -h | grep "usage: dsidm.*instance.*posixgroup rename"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup rename -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup rename demo_posix demo_posix |
        grep -i "Successfully renamed to cn=demo_posix,ou=groups,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup rename No Pass"
    dsidm localhost posixgroup delete -h | grep "usage: dsidm.*instance.*posixgroup delete"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup delete -h No Pass"
    dsidm -b "dc=example,dc=com" localhost posixgroup delete \
        "cn=demo_posix,ou=groups,dc=example,dc=com" 2>&1 | grep "has no len"
    CHECK_RESULT $? 0 0 "L$LINENO: posixgroup delete No Pass"
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
