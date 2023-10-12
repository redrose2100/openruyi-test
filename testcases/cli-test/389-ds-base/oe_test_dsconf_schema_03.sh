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
# @Author    :   liaoyuankun
# @Contact   :   1561203725@qq.com
# @Date      :   2023/8/31
# @License   :   Mulan PSL v2
# @Desc      :   Test dirsrv-snmp.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "389-ds-base"
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    ## suffixDN=dc=exmaple,dc=com   databse=example
    ## dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_schema_03."
    
    ### objectclasses query -h ###
    dsconf localhost schema objectclasses query -h | grep "usage: dsconf instance schema objectclasses query"
    CHECK_RESULT $? 0 0 "Check: objectclasses query -h No Pass" 
    
    ### objectclasses add -h ###
    dsconf localhost schema objectclasses add -h | grep "usage: dsconf instance schema objectclasses add"
    CHECK_RESULT $? 0 0 "Check: objectclasses add -h No Pass" 
    
    ### objectclasses add ###
    dsconf localhost schema objectclasses add --oid="2.16.840.1.1133730.2.1.99" --desc="An example person object class" --x-origin="Account Policy Plugin" --sup="top" --must="dateOfBirth" examplePerson | grep -E "values has to be a tuple"
    CHECK_RESULT $? 0 0 "Check: objectclasses add No Pass" 
    
    ### objectclasses replace -h ###
    dsconf localhost schema objectclasses replace -h | grep "usage: dsconf instance schema objectclasses replace"
    CHECK_RESULT $? 0 0 "Check: objectclasses replace -h No Pass" 
    
    ### objectclasses replace ###
    dsconf localhost schema objectclasses replace --desc="this desc replaced" account | grep "Cannot delete a standard object class"
    CHECK_RESULT $? 0 0 "Check: objectclasses replace No Pass" 
    
    ### objectclasses remove -h ###
    dsconf localhost schema objectclasses remove -h | grep "usage: dsconf instance schema objectclasses remove"
    CHECK_RESULT $? 0 0 "Check: objectclasses remove -h No Pass" 
    
    ### objectclasses remove ###
    dsconf localhost schema objectclasses remove account | grep "Cannot delete a standard object class"
    CHECK_RESULT $? 0 0 "Check: objectclasses remove No Pass" 
    
    ### matchingrules -h ###
    dsconf localhost schema matchingrules -h | grep "usage: dsconf instance schema matchingrules"
    CHECK_RESULT $? 0 0 "Check: matchingrules -h No Pass"
    
    ### matchingrules list -h ###
    dsconf localhost schema matchingrules list -h | grep -E "usage: dsconf instance schema matchingrules list"
    CHECK_RESULT $? 0 0 "Check: matchingrules list -h No Pass" 
    
    ### matchingrules list ###
    dsconf localhost schema matchingrules list | grep -E "booleanMatch"
    CHECK_RESULT $? 0 0 "Check: matchingrules list No Pass" 
    

    LOG_INFO "End to run testcase:oe_test_dsconf_schema_03."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
