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
# @Date      :   2023/10/12
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
    LOG_INFO "Start to run testcase:oe_test_dsconf_repl-conflict_01."
    ### repl-conflict list -h ###
    dsconf localhost repl-conflict list -h | grep -E "usage: dsconf instance repl-conflict list"
    CHECK_RESULT $? 0 0 "Check:  repl-conflict list -h No Pass" 

    ### repl-conflict list ###
    dsconf localhost repl-conflict list "dc=example,dc=com" | grep "no conflict"
    CHECK_RESULT $? 0 0 "Check:  repl-conflict list  No Pass" 

    ### repl-conflict compare -h ###
    dsconf localhost repl-conflict compare -h | grep -E "usage: dsconf instance repl-conflict compare"
    CHECK_RESULT $? 0 0 "Check: repl-conflict compare -h No Pass" 

    ### repl-conflict compare ###
    dsconf localhost repl-conflict compare "dc=example,dc=com" | grep "No such object"
    CHECK_RESULT $? 0 0 "Check: repl-conflict compare -h No Pass"
    
    ### repl-conflict delete -h ###
    dsconf localhost repl-conflict delete -h | grep -E "usage: dsconf instance repl-conflict delete"
    CHECK_RESULT $? 0 0 "Check: repl-conflict delete -h No Pass" 

    ### repl-conflict delete ###
    dsconf localhost repl-conflict delete "dc=example,dc=com" | grep "No such object"
    CHECK_RESULT $? 0 0 "Check: repl-conflict delete No Pass"
    
    ### repl-conflict swap -h ###
    dsconf localhost repl-conflict swap -h | grep -E "usage: dsconf instance repl-conflict swap"
    CHECK_RESULT $? 0 0 "Check: repl-conflict swap -h No Pass"

    ### repl-conflict swap  ###
    dsconf localhost repl-conflict swap "dc=example,dc=com" | grep "No such object"
    CHECK_RESULT $? 0 0 "Check: repl-conflict swap No Pass"
    
    ### repl-conflict convert -h ###
    dsconf localhost repl-conflict convert -h | grep -E "usage: dsconf instance repl-conflict convert"
    CHECK_RESULT $? 0 0 "Check: repl-conflict convert -h No Pass" 

    ### repl-conflict convert  ###
    dsconf localhost repl-conflict convert --new-rdn=cn=my_new_rdn_value dc=com,dc=example | grep "No such object"
    CHECK_RESULT $? 0 0 "Check: repl-conflict convert No Pass"  

    LOG_INFO "End to run testcase:oe_test_dsconf_repl-conflict_01."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
