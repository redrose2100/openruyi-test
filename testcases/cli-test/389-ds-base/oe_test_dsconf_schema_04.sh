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
    LOG_INFO "Start to run testcase:oe_test_dsconf_schema_04."
    
    ### matchingrules query ###
    dsconf localhost schema matchingrules query booleanMatch | grep -E "2.5.13.13"
    CHECK_RESULT $? 0 0 "Check: matchingrules query No Pass" 
    
    ### matchingrules query -h ###
    dsconf localhost schema matchingrules query -h | grep -E "usage: dsconf instance schema matchingrules query"
    CHECK_RESULT $? 0 0 "Check: matchingrules query -h No Pass" 
    
    ### reload -h ###
    dsconf localhost schema reload -h | grep -E "usage: dsconf instance schema reload"
    CHECK_RESULT $? 0 0 "Check: reload -h No Pass" 
    
    ### reload --wait ###
    dsconf localhost schema reload --wait | grep "successfully finished"
    CHECK_RESULT $? 0 0 "Check: reload --wait No Pass" 
    
    ### validate-syntax -h ###
    dsconf localhost schema validate-syntax -h | grep -E "usage: dsconf instance schema validate-syntax"
    CHECK_RESULT $? 0 0 "Check: validate-syntax -h No Pass" 
    
    ### validate-syntax -f ###
    dsconf localhost --verbose schema validate-syntax -f="FTPStatus" cn=example | grep -E "check logs"
    CHECK_RESULT $? 0 0 "Check: validate-syntax -f No Pass" 
    
    LOG_INFO "End to run testcase:oe_test_dsconf_schema_04."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
