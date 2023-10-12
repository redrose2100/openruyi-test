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
    LOG_INFO "Start to run testcase:oe_test_dsconf_repl-conflict_02."
    
    ### repl-conflict list-glue -h ###
    dsconf localhost repl-conflict list-glue -h | grep -E "usage: dsconf instance repl-conflict list-glue"
    CHECK_RESULT $? 0 0 "Check: repl-conflict list-glue -h No Pass" 

    ### repl-conflict list-glue ###
    dsconf localhost repl-conflict list-glue dc=example,dc=com | grep "no glue entries"
    CHECK_RESULT $? 0 0 "Check: repl-conflict list-glue No Pass"
    
    ### repl-conflict delete-glue -h ###
    dsconf localhost repl-conflict delete-glue -h | grep -E "usage: dsconf instance repl-conflict delete-glue"
    CHECK_RESULT $? 0 0 "Check: repl-conflict delete-glue -h No Pass" 

    ### repl-conflict delete-glue ###
    dsconf localhost repl-conflict delete-glue dc=example,dc=com | grep "No such object"
    CHECK_RESULT $? 0 0 "Check: repl-conflict delete-glue No Pass"
    
    ### repl-conflict convert-glue -h ###
    dsconf localhost repl-conflict convert-glue -h | grep -E "usage: dsconf instance repl-conflict convert-glue"
    CHECK_RESULT $? 0 0 "Check: repl-conflict convert-glue -h No Pass" 

    ### repl-conflict convert-glue ###
    dsconf localhost repl-conflict convert-glue dc=example,dc=com | grep "No such object"
    CHECK_RESULT $? 0 0 "Check: repl-conflict convert-glue No Pass"

    LOG_INFO "End to run testcase:oe_test_dsconf_repl-conflict_02."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
