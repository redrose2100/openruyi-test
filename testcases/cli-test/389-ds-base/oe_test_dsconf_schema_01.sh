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
    LOG_INFO "Start to run testcase:oe_test_dsconf_schema_01."
    
    ### -h ###
    dsconf localhost schema -h | grep -E "usage: dsconf instance schema" 
    CHECK_RESULT $? 0 0 "Check: schema -h No Pass" 
    
    ### list ###
    dsconf localhost schema list | grep -E "Objectclasses"
    CHECK_RESULT $? 0 0 "Check: list No Pass" 
    
    ### list -h ###
    dsconf localhost schema list -h | grep -E "usage: dsconf instance schema list"
    CHECK_RESULT $? 0 0 "Check: list -h No Pass" 
    
    ### attributetypes -h ###
    dsconf localhost schema attributetypes -h | grep -E "usage: dsconf instance schema attributetypes"
    CHECK_RESULT $? 0 0 "Check: attributetypes -h No Pass"
    
    ### get_syntaxes ###
    dsconf localhost schema attributetypes get_syntaxes | grep Telex
    CHECK_RESULT $? 0 0 "Check: get_syntaxes No Pass" 
    
    ### get_syntaxes -h ###
    dsconf localhost schema attributetypes get_syntaxes -h | grep -E "usage: dsconf instance schema attributetypes get_syntaxes"
    CHECK_RESULT $? 0 0 "Check: get_syntaxes -h No Pass" 
    
    ### attributetypes list ###
    dsconf localhost schema attributetypes list | grep -E "CACertExtractFile-oid"
    CHECK_RESULT $? 0 0 "Check: schema -h No Pass" 
    
    ### attributetypes list -h ###
    dsconf localhost schema attributetypes list -h | grep -E "usage: dsconf instance schema attributetypes list"
    CHECK_RESULT $? 0 0 "Check: schema -h No Pass" 
    
    ### attributetypes query -h ###
    dsconf localhost schema attributetypes query -h | grep "usage: dsconf instance schema attributetypes query"
    CHECK_RESULT $? 0 0 "Check: attributetypes query -h No Pass" 
    
    ### attributetypes query ###
    dsconf localhost schema attributetypes query FTPStatus | grep -E "FTPStatus"
    CHECK_RESULT $? 0 0 "Check: attributetypes query No Pass" 

    LOG_INFO "End to run testcase:oe_test_dsconf_schema_01."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
