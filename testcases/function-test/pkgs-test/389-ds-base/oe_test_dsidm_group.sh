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
#@Desc      :   Test "dsctk" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export NSSLAPD_DB_LIB=bdb
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
    dsidm localhost group -h | grep "usage: dsidm.*instance.*group"
    CHECK_RESULT $? 0 0 "L$LINENO: group -h No Pass"
    dsidm localhost group list -h | grep "usage: dsidm.*instance.*group list"
    CHECK_RESULT $? 0 0 "L$LINENO: group list -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group list | grep "demo_group"
    CHECK_RESULT $? 0 0 "L$LINENO: group list No Pass"
    dsidm localhost group get -h | grep "usage: dsidm.*instance.*group get"
    CHECK_RESULT $? 0 0 "L$LINENO: group get -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group get "demo_group" | grep "cn: demo_group"
    CHECK_RESULT $? 0 0 "L$LINENO: group get No Pass"
    dsidm localhost group get_dn -h | grep "usage: dsidm.*instance.*group get_dn"
    CHECK_RESULT $? 0 0 "L$LINENO: group get_dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group get_dn "cn=demo_group,ou=groups,dc=example,dc=com" | grep "demo_group"
    CHECK_RESULT $? 0 0 "L$LINENO: group get_dn No Pass"
    dsidm localhost group create -h | grep "usage: dsidm.*instance.*group create"
    CHECK_RESULT $? 0 0 "L$LINENO: group create -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group create --cn demo_group2 | grep "Successfully created demo_group2"
    CHECK_RESULT $? 0 0 "L$LINENO: group create No Pass"
    dsidm localhost group modify -h | grep "usage: dsidm.*instance.*group modify"
    CHECK_RESULT $? 0 0 "L$LINENO: group modify -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group modify demo_group2 replace:cn:demo_group2 |
        grep -i "Successfully modified cn=demo_group2,ou=groups,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: group modify No Pass"
    dsidm localhost group rename -h | grep "usage: dsidm.*instance.*group rename"
    CHECK_RESULT $? 0 0 "L$LINENO: group rename -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group rename demo_group2 demo_group2 |
        grep -i "Successfully renamed to cn=demo_group2,ou=groups,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: group rename No Pass"
    dsidm localhost group members -h | grep "usage: dsidm.*instance.*group members"
    CHECK_RESULT $? 0 0 "L$LINENO: group members -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group members demo_group | grep "No members to display"
    CHECK_RESULT $? 0 0 "L$LINENO: group members -h No Pass"
    dsidm localhost group add_member -h | grep "usage: dsidm.*instance.*group add_member"
    CHECK_RESULT $? 0 0 "L$LINENO: group add_member -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group add_member demo_group2 "uid=demo_user,ou=people,dc=example,dc=com" |
        grep "added member: uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: group add_member No Pass"
    dsidm localhost group remove_member -h | grep "usage: dsidm.*instance.*group remove_member"
    CHECK_RESULT $? 0 0 "L$LINENO: group remove_member -h No Pass"
    dsidm -b "dc=example,dc=com" localhost group remove_member demo_group2 "uid=demo_user,ou=people,dc=example,dc=com" |
        grep "removed member: uid=demo_user,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: group remove_member No Pass"
    dsidm localhost group delete -h | grep "usage: dsidm.*instance.*group delete"
    CHECK_RESULT $? 0 0 "L$LINENO: group delete -h No Pass"
    echo "Yes I am sure" | dsidm -b "dc=example,dc=com" localhost group delete \
        "cn=demo_group2,ou=groups,dc=example,dc=com" | grep "Successfully deleted cn=demo_group2,ou=groups,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: group delete No Pass"
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
