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
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### config -h
    dsconf localhost config -h | grep  "usage: dsconf instance config" 
    CHECK_RESULT $? 0 0 "Check: config -h No Pass" 
   ### get -h
    dsconf localhost config get -h | grep  "usage: dsconf instance config get" 
    CHECK_RESULT $? 0 0 "Check: config get -h No Pass" 
    ### get 
    dsconf localhost config get  | grep  "dn: cn=config" 
    CHECK_RESULT $? 0 0 "Check: config get  No Pass" 
    ### add -h
    dsconf localhost config add -h | grep  "usage: dsconf instance config add" 
    CHECK_RESULT $? 0 0 "Check: config add -h No Pass" 
    ### add 
    dsconf localhost config add olcLogLevel 256 | grep  "Error: You must specify a value to add for the attribute" 
    CHECK_RESULT $? 0 0 "Check: config get  No Pass" 
    ### replace -h
    dsconf localhost config replace -h | grep  "usage: dsconf instance config replace" 
    CHECK_RESULT $? 0 0 "Check: config replace -h No Pass" 
    ### replace
    dsconf localhost config replace olcLogLevel 512 | grep  "Error: You must specify a value to replace the attribute" 
    CHECK_RESULT $? 0 0 "Check: config replace  No Pass" 

    ### delete -h
    dsconf localhost config delete -h | grep  "usage: dsconf instance config delete" 
    CHECK_RESULT $? 0 0 "Check: config delete -h No Pass" 
    ### delete 
    dsconf localhost config delete nsslapd-accesslog-mode  | grep  "Successfully removed " 
    CHECK_RESULT $? 0 0 "Check: config get  No Pass" 


    LOG_INFO "End to run testcase:oe_test_dsconf_backend."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
