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
    dsidm -h | grep "usage: dsidm"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    dsidm -D "cn=Directory Manage" -b "dc=example,dc=com" localhost user list | grep "demo_user"
    CHECK_RESULT $? 0 0 "L$LINENO: -b -D No Pass"
    dsidm -W -w 12345678 -D "cn=Directory Manage" -b "dc=example,dc=com" localhost user list | grep "demo_user"
    CHECK_RESULT $? 0 0 "L$LINENO: -w -W No Pass"
    dsidm -v -b "dc=example,dc=com" localhost user list | grep "INFO: demo_user"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    dsidm -y instance.inf -b "dc=example,dc=com" localhost user list | grep "demo_user"
    CHECK_RESULT $? 0 0 "L$LINENO: -y No Pass"
    dsidm -j -Z -b "dc=example,dc=com" localhost user list 2>&1 | grep "Start TLS request accepted"
    CHECK_RESULT $? 0 0 "L$LINENO: -Z No Pass"
    dsidm -j -b "dc=example,dc=com" localhost user list | grep "\"type\": \"list\""
    CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
    dsidm localhost initialise -h | grep "usage: dsidm.*instance.*initialise"
    CHECK_RESULT $? 0 0 "L$LINENO: initialise -h No Pass"
    dsidm -b "dc=example,dc=com" localhost initialise 2>&1 | grep "Already exists"
    CHECK_RESULT $? 0 0 "L$LINENO: initialise No Pass"
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
