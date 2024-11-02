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
# @Author    :   tanxin
# @Contact   :   njutanx@163.com
# @Date      :   2023/8/13
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost chaining -h | grep  "usage: dsconf.* instance chaining" 
    CHECK_RESULT $? 0 0 "Check: chaining -h No Pass" 
    dsconf localhost chaining config-get -h | grep  "usage: dsconf.* instance chaining config-get" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get -h No Pass" 
    dsconf localhost chaining config-get --avail-controls | grep -iE "Available Components:" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get --avail-controls No Pass" 
    dsconf localhost chaining config-get --avail-comps | grep -iE "Available Controls:" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get --avail-comps No Pass"
    dsconf localhost chaining config-set -h | grep  "usage: dsconf.* instance chaining config-set" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set -h No Pass" 
    dsconf localhost chaining config-set --add-control 1.3.6.1.4.1.12345.1 | grep -iE "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set -add-control No Pass" 
    dsconf localhost chaining config-set --del-control 1.3.6.1.4.1.12345.1 | grep -iE "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set --del-control No Pass"
    dsconf localhost chaining config-set --add-comp chain_component1 | grep -iE "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set ---add-comp chain_component1 No Pass"
    dsconf localhost chaining config-set --del-comp chain_component1 | grep -iE "Successfully updated chaining configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set ---del-comp chain_component1 No Pass"
    dsconf localhost chaining config-get-def -h | grep  "usage: dsconf.* instance chaining config-get-def" 
    CHECK_RESULT $? 0 0 "Check: chaining config-get-def -h No Pass" 
    dsconf localhost chaining config-set-def -h | grep  "usage: dsconf.* instance chaining config-set-def" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def -h No Pass" 
    dsconf localhost chaining config-set-def --conn-bind-limit 100 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-bind-limit No Pass" 
    dsconf localhost chaining config-set-def --conn-op-limit 50 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-op-limit No Pass" 
    dsconf localhost chaining config-set-def --abandon-check-interval 30 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --abandon-check-interval No Pass" 
    dsconf localhost chaining config-set-def --bind-limit 10 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --bind-limit No Pass" 
    dsconf localhost chaining config-set-def --op-limit 100 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --op-limit No Pass" 
    dsconf localhost chaining config-set-def --proxied-auth off | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --proxied-auth No Pass" 
    dsconf localhost chaining config-set-def --conn-lifetime 3600 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-lifetime No Pass" 
    dsconf localhost chaining config-set-def --bind-timeout 5 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --bind-timeout No Pass" 
    dsconf localhost chaining config-set-def --return-ref off | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --return-ref No Pass" 
    dsconf localhost chaining config-set-def --check-aci on | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --check-aci No Pass" 
    dsconf localhost chaining config-set-def --bind-attempts 3 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --bind-attempts No Pass" 
    dsconf localhost chaining config-set-def --size-limit 1000 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --size-limit No Pass" 
    dsconf localhost chaining config-set-def --time-limit 30 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --time-limit No Pass" 
    dsconf localhost chaining config-set-def --hop-limit 5 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --hop-limit No Pass" 
    dsconf localhost chaining config-set-def --response-delay 10 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --response-delay No Pass" 
    dsconf localhost chaining config-set-def --test-response-delay 2 | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --test-response-delay No Pass" 
    dsconf localhost chaining config-set-def --use-starttls on | grep -iE "Successfully updated chaining default instance creation configuration" 
    CHECK_RESULT $? 0 0 "Check: chaining config-set-def --use-starttls No Pass" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"