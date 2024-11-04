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
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf -h | grep  "usage: dsconf"
    CHECK_RESULT $? 0 0 "Check: -h No Pass"        
    dsconf localhost -v backend create --suffix dc=example,dc=com --be-name example | grep  "INFO: Command successful."
    CHECK_RESULT $? 0 0 "Check: -v No Pass" 
    dsconf -D "cn=Directory Manage" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -D No Pass" 
    dsconf -w "Direcotry_Manager_Password" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -w No Pass" 
    dsconf -W -w "Direcotry_Manager_Password" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -W No Pass" 
    dsconf -y 389_ds_test.inf  localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -y No Pass" 
    dsconf -D "cn=Directory Manage" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -b No Pass" 
    dsconf -Z -b "dc=example,dc=com" localhost backend suffix list 2>& 1 | grep  "Start TLS request accepted"
    CHECK_RESULT $? 0 0 "Check: -Z No Pass" 
    dsconf -j -b "dc=example,dc=com" localhost backend suffix list | grep "\"type\": \"list\""
    CHECK_RESULT $? 0 0 "Check: -j No Pass" 
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