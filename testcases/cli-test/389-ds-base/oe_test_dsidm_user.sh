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
    dsidm localhost user -h | grep "usage: dsidm.* instance user"
    CHECK_RESULT $? 0 0 "L$LINENO: user -h No Pass"
    dsidm localhost user list -h | grep "usage: dsidm.* instance user list"
    CHECK_RESULT $? 0 0 "L$LINENO: user list -h No Pass"
    dsidm -b "dc=example,dc=com" localhost user list | grep "demo_user"
    CHECK_RESULT $? 0 0 "L$LINENO: user list No Pass"
    dsidm localhost user get -h | grep "usage: dsidm.* instance user get"
    CHECK_RESULT $? 0 0 "L$LINENO: user get -h No Pass"
    dsidm -b "dc=example,dc=com" localhost user get demo_user | grep "uid: demo_user"
    CHECK_RESULT $? 0 0 "L$LINENO: user get No Pass"
    dsidm localhost user get_dn -h | grep "usage: dsidm.* instance user get_dn"
    CHECK_RESULT $? 0 0 "L$LINENO: user get_dn -h No Pass"
    dsidm localhost user create -h | grep "usage: dsidm.* instance user create"
    CHECK_RESULT $? 0 0 "L$LINENO: user create -h No Pass"
    dsidm -b "dc=example,dc=com" localhost user create --uid 123456\
    --cn demo_cn --displayName demo_name --uidNumber 123456 --gidNumber 1000 \
    --homeDirectory /home/william  | grep "Successfully created 123456"
    CHECK_RESULT $? 0 0 "L$LINENO: user create No Pass"
    dsidm localhost user modify -h | grep "usage: dsidm.* instance user modify"
    CHECK_RESULT $? 0 0 "L$LINENO: user modify -h No Pass"
    dsidm -b "dc=example,dc=com" localhost user modify 123456 replace:displayName:demo_name_change | \
    grep "Successfully modified uid=123456,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: user modify No Pass"
    dsidm localhost user rename -h | grep "usage: dsidm.* instance user rename"
    CHECK_RESULT $? 0 0 "L$LINENO: user rename -h No Pass"
    dsidm -b "dc=example,dc=com" localhost user rename 123456 demo_cn_change --keep-old-rdn | \
    grep "Successfully renamed to uid=demo_cn_change,ou=people,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: user rename No Pass"
    dsidm localhost user delete -h | grep "usage: dsidm.* instance user delete"
    CHECK_RESULT $? 0 0 "L$LINENO: user delete -h No Pass"
    echo "Yes I am sure" | dsidm -b "dc=example,dc=com" localhost user delete \
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