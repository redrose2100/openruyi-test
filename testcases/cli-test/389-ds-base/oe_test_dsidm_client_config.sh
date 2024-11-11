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
    dsidm localhost client_config -h | grep "usage: dsidm.* instance client_config"
    CHECK_RESULT $? 0 0 "L$LINENO: client_config -h No Pass"
    dsidm localhost client_config display -h | grep "usage: dsidm.* instance client_config display "
    CHECK_RESULT $? 0 0 "L$LINENO: client_config display -h No Pass"
    dsidm -b "dc=example,dc=com" localhost client_config display | grep "group member attribute = member"
    CHECK_RESULT $? 0 0 "L$LINENO: client_config display No Pass"
    dsidm localhost client_config sssd.conf -h | grep "usage: dsidm.* instance client_config sssd.conf "
    CHECK_RESULT $? 0 0 "L$LINENO: client_config sssd.conf -h No Pass"
    dsidm -b "dc=example,dc=com" localhost client_config sssd.conf demo_group  | grep "domains = ldap"
    CHECK_RESULT $? 0 0 "L$LINENO: client_config sssd.conf No Pass"
    dsidm localhost client_config ldap.conf -h | grep "usage: dsidm.* instance client_config ldap.conf "
    CHECK_RESULT $? 0 0 "L$LINENO: client_config ldap.conf -h No Pass"
    dsidm -b "dc=example,dc=com" localhost client_config ldap.conf | grep "DEREF   never"
    CHECK_RESULT $? 0 0 "L$LINENO: client_config ldap.conf No Pass"
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