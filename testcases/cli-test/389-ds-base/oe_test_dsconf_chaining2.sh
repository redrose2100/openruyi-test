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
    ### link-create -h
    dsconf localhost chaining link-create -h | grep  "usage: dsconf instance chaining link-create" 
    CHECK_RESULT $? 0 0 "Check: chaining link-create -h No Pass" 
    ### link-create all
    dsctl localhost start
    dsconf localhost chaining link-create --conn-bind-limit 100 --conn-op-limit 200 --abandon-check-interval 60 --bind-limit 50 --op-limit 100 --proxied-auth on --conn-lifetime 3600 --bind-timeout 10 --return-ref off --check-aci on --bind-attempts 3 --size-limit 1000 --time-limit 60 --hop-limit 5 --response-delay 10 --test-response-delay 5 --use-starttls off --suffix "dc=example,dc=com" --server-url ldap://example.com:389 --bind-mech simple --bind-dn "cn=admin,dc=example,dc=com" --bind-pw "password"  link1 | grep -E  "Successfully created database link|Type or value exists"
    CHECK_RESULT $? 0 0 "Check: chaining link-create all No Pass" 
    ### link-get -h
    dsconf localhost chaining link-get -h | grep  "usage: dsconf instance chaining link-get" 
    CHECK_RESULT $? 0 0 "Check: chaining link-get -h No Pass" 
    ### link-set -h
    dsconf localhost chaining link-set -h | grep  "usage: dsconf instance chaining link-set" 
    CHECK_RESULT $? 0 0 "Check: chaining link-set -h No Pass" 
    ### link-set --conn-bind-limit
    dsconf localhost chaining link-set --conn-bind-limit 200 link1 | grep  "Successfully updated database chaining link" 
    CHECK_RESULT $? 0 0 "Check: chaining link-set --conn-bind-limit No Pass" 


    ### link-get -h
    dsconf localhost chaining link-get -h | grep  "usage: dsconf instance chaining link-get" 
    CHECK_RESULT $? 0 0 "Check: chaining link-get -h No Pass" 
    ### link-get
    dsconf localhost chaining link-get link1 | grep  "cn: link1" 
    CHECK_RESULT $? 0 0 "Check: chaining link-get  No Pass"
    ### link-list -h
    dsconf localhost chaining link-list -h | grep  "usage: dsconf instance chaining link-list" 
    CHECK_RESULT $? 0 0 "Check: chaining link-list -h No Pass" 
    ### link-list
    dsconf localhost chaining link-list | grep  "link1" 
    CHECK_RESULT $? 0 0 "Check: chaining link-list  No Pass"
    ### monitor -h
    dsconf localhost chaining monitor -h | grep  "usage: dsconf instance chaining monitor" 
    CHECK_RESULT $? 0 0 "Check: chaining monitor -h No Pass" 
    ### monitor
    dsconf localhost chaining monitor link1 | grep  "dn: cn=monitor" 
    CHECK_RESULT $? 0 0 "Check: chaining monitor  No Pass" 

    ### link-delete  -h
    dsconf localhost chaining link-delete -h | grep  "usage: dsconf instance chaining link-delete" 
    CHECK_RESULT $? 0 0 "Check: chaining link-delete -h No Pass" 
    ### link-delete 
    dsconf localhost chaining link-delete link1 | grep  "Successfully deleted database link" 
    CHECK_RESULT $? 0 0 "Check: chaining link-delete -h No Pass" 
    
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
