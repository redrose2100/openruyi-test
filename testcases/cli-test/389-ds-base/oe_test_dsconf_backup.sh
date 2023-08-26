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
    ## indexDN=dc=exmaple,dc=com   databse=example
     dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### backup -h
    dsconf localhost backup -h | grep  "usage: dsconf instance backup" 
    CHECK_RESULT $? 0 0 "Check: backup -h No Pass" 
    ### backup create -h
    dsconf localhost backup create -h | grep  "usage: dsconf instance backup create" 
    CHECK_RESULT $? 0 0 "Check: backup create -h No Pass" 
    ### backup create -t
    #dsconf localhost backup create -t | grep  "There is no backend/suffix present" 
    #CHECK_RESULT $? 0 0 "Check: backup create -th No Pass" 
    ### backup restore -h
    dsconf localhost backup restore -h | grep  "usage: dsconf instance backup restore" 
    CHECK_RESULT $? 0 0 "Check: backup restore -h No Pass" 
    ### backup restore -t
    #dsconf localhost backup restore -t | grep  "" 
    #CHECK_RESULT $? 0 0 "Check: backup restore -t No Pass" 

    LOG_INFO "End to run testcase:oe_test_dsconf_backend."
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
