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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_389_ds_base."
    ### -h ###
    dsconf -h | grep  "usage: dsconf"
    CHECK_RESULT $? 0 0 "Check: -h No Pass"        
    ### -v ###
    dsconf INSTANCE_PATH -v | grep  "DEBUG"
    CHECK_RESULT $? 0 0 "Check: -v No Pass" 
    ### -D ###
    dsconf INSTANCE_PATH -D BIND_DN | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -v No Pass" 
    ### -w ###
    dsconf INSTANCE_PATH -w  PASSWORD | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -w No Pass" 
    ### -W ###
    dsconf INSTANCE_PATH -W | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -W No Pass" 
    ### -y ###
    dsconf  INSTANCE_PATH -y  FILE_PATH | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -y No Pass" 
    ### -b ###
    dsconf  INSTANCE_PATH -b  "$BASE_DN" | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -b No Pass"
    ### -Z ###
    dsconf  INSTANCE_PATH -Z   | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -Z No Pass" 
    ### -j ###
    dsconf  INSTANCE_PATH -j   | grep  "No action provided"
    CHECK_RESULT $? 0 0 "Check: -j No Pass" 
    ### +backend ###
    dsconf  INSTANCE_PATH backend -h   | grep  "usage: dsconf instance backend"
    CHECK_RESULT $? 0 0 "Check: +backend No Pass" 
    ### +backup ###
    dsconf  INSTANCE_PATH backup -h   | grep  "usage: dsconf instance backup"
    CHECK_RESULT $? 0 0 "Check: +backup No Pass" 
    ### +chaining ###
    dsconf  INSTANCE_PATH chaining -h   | grep  "usage: dsconf instance chaining"
    CHECK_RESULT $? 0 0 "Check: +chaining No Pass" 
    ### +config ###
    dsconf  INSTANCE_PATH config -h   | grep  "usage: dsconf instance config"
    CHECK_RESULT $? 0 0 "Check: +config No Pass" 
    ### +directory_manager ###
    dsconf  INSTANCE_PATH directory_manager -h   | grep  "usage: dsconf instance directory_manager"
    CHECK_RESULT $? 0 0 "Check: +directory_manager No Pass" 
    ### +monitor ###
    dsconf  INSTANCE_PATH monitor -h   | grep  "usage: dsconf instance monitor"
    CHECK_RESULT $? 0 0 "Check: +monitor No Pass" 
    ### +plugin ###
    dsconf  INSTANCE_PATH plugin -h   | grep  "usage: dsconf instance plugin"
    CHECK_RESULT $? 0 0 "Check: +plugin No Pass" 
    ### +pwpolicy ###
    dsconf  INSTANCE_PATH pwpolicy -h   | grep  "usage: dsconf instance pwpolicy"
    CHECK_RESULT $? 0 0 "Check: +pwpolicy No Pass" 
    ### +localpwp ###
    dsconf  INSTANCE_PATH localpwp -h   | grep  "usage: dsconf instance localpwp"
    CHECK_RESULT $? 0 0 "Check: +localpwp No Pass" 
    ### +replication ###
    dsconf  INSTANCE_PATH replication -h   | grep  "usage: dsconf instance replication"
    CHECK_RESULT $? 0 0 "Check: +replication No Pass" 
    ### +repl-agmt ###
    dsconf  INSTANCE_PATH repl-agmt -h   | grep  "usage: dsconf instance repl-agmt"
    CHECK_RESULT $? 0 0 "Check: +repl-agmt No Pass" 
    ### +repl-winsync-agmt ###
    dsconf  INSTANCE_PATH repl-winsync-agmt -h   | grep  "usage: dsconf instance repl-winsync-agmt"
    CHECK_RESULT $? 0 0 "Check: +repl-winsync-agmt No Pass" 
    ### +repl-tasks ###
    dsconf  INSTANCE_PATH repl-tasks -h   | grep  "usage: dsconf instance repl-tasks"
    CHECK_RESULT $? 0 0 "Check: +repl-tasks No Pass" 
    ### +sasl ###
    dsconf  INSTANCE_PATH sasl -h   | grep  "usage: dsconf instance sasl"
    CHECK_RESULT $? 0 0 "Check: +sasl No Pass" 
    ### +security ###
    dsconf  INSTANCE_PATH security -h   | grep  "usage: dsconf instance security"
    CHECK_RESULT $? 0 0 "Check: +security No Pass" 
    ### +schema ###
    dsconf  INSTANCE_PATH schema -h   | grep  "usage: dsconf instance schema"
    CHECK_RESULT $? 0 0 "Check: +schema No Pass" 
    ### +repl-conflict ###
    dsconf  INSTANCE_PATH repl-conflict -h   | grep  "usage: dsconf instance repl-conflict"
    CHECK_RESULT $? 0 0 "Check: +repl-conflict No Pass" 

    LOG_INFO "End to run testcase:oe_test_dsconf_389_ds_base."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
