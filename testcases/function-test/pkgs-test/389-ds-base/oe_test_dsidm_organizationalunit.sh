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
    cat <<EOF > instance.inf
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
    dsidm localhost organizationalunit -h | grep "usage: dsidm.* instance organizationalunit"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit -h No Pass"
    dsidm localhost organizationalunit list -h | grep "usage: dsidm.* instance organizationalunit list"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit list -h No Pass"
    dsidm -b "dc=example,dc=com" localhost organizationalunit list | grep "groups"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit list No Pass"
    dsidm localhost organizationalunit get -h | grep "usage: dsidm.* instance organizationalunit get"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get -h No Pass"
    dsidm -b "dc=example,dc=com" localhost organizationalunit get "groups" | grep "ou: groups"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get No Pass"
    dsidm localhost organizationalunit get_dn -h | grep "usage: dsidm.* instance organizationalunit get_dn"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get_dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost organizationalunit get_dn "ou=groups,dc=example,dc=com" 2>&1 | \
    grep "argument 1 must be str, not function"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get_dn No Pass"
    dsidm localhost organizationalunit create -h | grep "usage: dsidm.* instance organizationalunit create"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit create -h No Pass"
    dsidm -b "dc=example,dc=com" localhost organizationalunit create --ou demo_ou  | grep "Successfully created demo_ou"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit create No Pass"
    dsidm localhost organizationalunit modify -h | grep "usage: dsidm.* instance organizationalunit modify"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit modify -h No Pass"
    dsidm -b "dc=example,dc=com" localhost organizationalunit modify demo_ou replace:ou:demo_ou | \
    grep "Successfully modified ou=demo_ou,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit modify No Pass"
    dsidm localhost organizationalunit rename -h | grep "usage: dsidm.* instance organizationalunit rename"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit rename -h No Pass"
    dsidm -b "dc=example,dc=com" localhost organizationalunit rename demo_ou demo_ou | \
    grep "Successfully renamed to ou=demo_ou,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit rename No Pass"
    dsidm localhost organizationalunit delete -h | grep "usage: dsidm.* instance organizationalunit delete"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit delete -h No Pass"
    echo "Yes I am sure" | dsidm -b "dc=example,dc=com" localhost organizationalunit delete \
    "ou=demo_ou,dc=example,dc=com" | grep "Successfully deleted ou=demo_ou,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit delete No Pass"
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