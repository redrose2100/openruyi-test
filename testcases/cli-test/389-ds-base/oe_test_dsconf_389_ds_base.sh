#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test dirsrv-snmp.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "389-ds-base"
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_389_ds_base."
    ### -h ###
    dsconf -h | grep  "usage: dsconf"
    CHECK_RESULT $? 0 0 "Check: -h No Pass"        
    ### -v ###
    dsconf localhost -v backend create --suffix dc=example,dc=com --be-name example | grep  "INFO: Command successful."
    CHECK_RESULT $? 0 0 "Check: -v No Pass" 
    ### -D ###
    dsconf -D "cn=Directory Manage" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -D No Pass" 
    ### -w ###
    dsconf -w "Direcotry_Manager_Password" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -w No Pass" 
    ### -W ###
    dsconf -W -w "Direcotry_Manager_Password" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -W No Pass" 
    ### -y ###
    dsconf -y 389_ds_test.inf  localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -y No Pass" 
    ### -b ###
    dsconf -D "cn=Directory Manage" -b "dc=example,dc=com" localhost backend suffix list | grep  "dc=example,dc=com (example)"
    CHECK_RESULT $? 0 0 "Check: -b No Pass" 
    ### -Z ###
    dsconf -Z -b "dc=example,dc=com" localhost backend suffix list  | grep  "Start TLS request accepted"
    CHECK_RESULT $? 0 0 "Check: -Z No Pass" 
    ### -j ###
    dsconf -j -b "dc=example,dc=com" localhost backend suffix list   | grep -E "\"type\": \"list\""
    CHECK_RESULT $? 0 0 "Check: -j No Pass" 


    LOG_INFO "End to run testcase:oe_test_dsconf_389_ds_base."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
