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
    ### chaining -h
    dsconf localhost chaining -h | grep  "usage: dsconf instance chaining" 
    CHECK_RESULT $? 0 0 "Check: chaining -h No Pass" 
    ### config-get -h
    dsconf localhost chaining config-get -h | grep  "usage: dsconf instance chaining config-get" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get -h No Pass" 
    ### config-get --avail-controls
    dsconf localhost chaining config-get --avail-controls | grep  "Available Components:" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get --avail-controls No Pass" 
    ### config-get --avail-comps
    dsconf localhost chaining config-get --avail-comps | grep  "Available Controls:" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get --avail-comps No Pass"
    ### config-set -h
    dsconf localhost chaining config-set -h | grep  "usage: dsconf instance chaining config-set" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set -h No Pass" 
    ### config-set --add-control
    dsconf localhost chaining config-set --add-control 1.3.6.1.4.1.12345.1 | grep  "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set -add-control No Pass" 
    ### config-set --del-control
    dsconf localhost chaining config-set --del-control 1.3.6.1.4.1.12345.1 | grep  "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set --del-control No Pass"
    ### config-set --add-comp
    dsconf localhost chaining config-set --add-comp chain_component1 | grep  "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set ---add-comp chain_component1 No Pass"
    ### config-set --del-comp
    dsconf localhost chaining config-set --del-comp chain_component1 | grep  "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set ---del-comp chain_component1 No Pass"
    ### config-get-def -h
    dsconf localhost chaining config-get-def -h | grep  "usage: dsconf instance chaining config-get-def" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get-def -h No Pass" 

    ### config-set-def -h
    dsconf localhost chaining config-set-def -h | grep  "usage: dsconf instance chaining config-set-def" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def -h No Pass" 
    ### config-set-def --conn-bind-limit
    dsconf localhost chaining config-set-def --conn-bind-limit 100 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-bind-limit No Pass" 
    ### config-set-def --conn-op-limit
    dsconf localhost chaining config-set-def --conn-op-limit 50 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-op-limit No Pass" 
    ### config-set-def --abandon-check-interval
    dsconf localhost chaining config-set-def --abandon-check-interval 30 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --abandon-check-interval No Pass" 
    ### config-set-def --bind-limit
    dsconf localhost chaining config-set-def --bind-limit 10 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --bind-limit No Pass" 
    ### config-set-def --op-limit
    dsconf localhost chaining config-set-def --op-limit 100 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --op-limit No Pass" 
    ### config-set-def --proxied-auth
    dsconf localhost chaining config-set-def --proxied-auth off | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --proxied-auth No Pass" 
    ### config-set-def --conn-lifetime
    dsconf localhost chaining config-set-def --conn-lifetime 3600 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-lifetime No Pass" 
    ### config-set-def --bind-timeout
    dsconf localhost chaining config-set-def --bind-timeout 5 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --bind-timeout No Pass" 
    ### config-set-def --return-ref
    dsconf localhost chaining config-set-def --return-ref off | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --return-ref No Pass" 
    ### config-set-def --check-aci
    dsconf localhost chaining config-set-def --check-aci on | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --check-aci No Pass" 
    ### config-set-def --bind-attempts
    dsconf localhost chaining config-set-def --bind-attempts 3 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --bind-attempts No Pass" 
    ### config-set-def --size-limit
    dsconf localhost chaining config-set-def --size-limit 1000 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --size-limit No Pass" 
    ### config-set-def --time-limit
    dsconf localhost chaining config-set-def --time-limit 30 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --time-limit No Pass" 
    ### config-set-def --hop-limit
    dsconf localhost chaining config-set-def --hop-limit 5 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --hop-limit No Pass" 
    ### config-set-def --response-delay
    dsconf localhost chaining config-set-def --response-delay 10 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --response-delay No Pass" 
    ### config-set-def --test-response-delay
    dsconf localhost chaining config-set-def --test-response-delay 2 | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --test-response-delay No Pass" 
    ### config-set-def --use-starttls
    dsconf localhost chaining config-set-def --use-starttls on | grep  "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --use-starttls No Pass" 
    
    
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
