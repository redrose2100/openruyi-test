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
# @Date      :   2023/8/29
# @License   :   Mulan PSL v2
# @Desc      :   Test dirsrv-snmp.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "389-ds-base"
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    dsconf localhost chaining link-create --conn-bind-limit 100 --conn-op-limit 200 --abandon-check-interval 60 --bind-limit 50 --op-limit 100 --proxied-auth on --conn-lifetime 3600 --bind-timeout 10 --return-ref off --check-aci on --bind-attempts 3 --size-limit 1000 --time-limit 60 --hop-limit 5 --response-delay 10 --test-response-delay 5 --use-starttls off --suffix "dc=example,dc=com" --server-url ldap://example.com:389 --bind-mech simple --bind-dn "cn=admin,dc=example,dc=com" --bind-pw "password"  link1
    cat << EOT > change.sh
    #!/bin/bash
    expect << EOF
    spawn dsconf localhost directory_manager password_change
    expect "Enter new directory manager password:"
    send "123456\r"
    expect "CONFIRM - Enter new directory manager password:"
    send "123456\r"
    expect eof
EOF
EOT
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### directory_manager -h
    dsconf localhost directory_manager -h | grep  "usage: dsconf instance directory_manager" 
    CHECK_RESULT $? 0 0 "Check: backend directory_manager -h No Pass" 
    ### password_change -h
    dsconf localhost directory_manager password_change -h | grep  "usage: dsconf instance directory_manager password_change" 
    CHECK_RESULT $? 0 0 "Check: backend directory_manager password_change -h No Pass"
    ### password_change
    bash ./change.sh 
    CHECK_RESULT $? 0 0 "Check: backend directory_manager password_change  No Pass"


    ### monitor -h
    dsconf localhost monitor -h | grep  "usage: dsconf instance monitor" 
    CHECK_RESULT $? 0 0 "Check: backend monitor -h No Pass" 
    ### server -h
    dsconf localhost monitor server -h | grep  "usage: dsconf instance monitor server" 
    CHECK_RESULT $? 0 0 "Check: backend monitor server-h No Pass" 
    ### dbmon -h
    dsconf localhost monitor dbmon -h | grep  "usage: dsconf instance monitor dbmon" 
    CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -h No Pass" 
    ### dbmon -b
    dsconf localhost monitor dbmon -b example | grep  "DB Monitor Report" 
    CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -b No Pass" 
    ### dbmon -x
    dsconf localhost monitor dbmon -b example -x | grep  "Indexes:" 
    CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -x No Pass" 
    ### ldbm -h
    dsconf localhost monitor ldbm -h | grep  "usage: dsconf instance monitor ldbm" 
    CHECK_RESULT $? 0 0 "Check: backend monitor ldbm -h No Pass" 
    ### backend -h
    dsconf localhost monitor backend -h | grep  "usage: dsconf instance monitor backend" 
    CHECK_RESULT $? 0 0 "Check: backend monitor backend -h No Pass" 
    ### backend [backend]
    dsconf localhost monitor backend example | grep  "dn: cn=monitor,cn=example,cn=ldbm database,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: backend monitor backend [backend] No Pass" 
    ### snmp -h
    dsconf localhost monitor snmp -h | grep  "usage: dsconf instance monitor snmp" 
    CHECK_RESULT $? 0 0 "Check: backend monitor snmp -h No Pass" 
    ### chaining -h
    dsconf localhost monitor chaining -h | grep  "usage: dsconf instance monitor chaining" 
    CHECK_RESULT $? 0 0 "Check: backend monitor chaining -h No Pass" 
    ### chaining [backend]
    dsconf localhost monitor chaining link1 | grep  "dn: cn=monitor,cn=link1,cn=chaining database,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: backend monitor chaining [backend] No Pass" 
    ### disk -h
    dsconf localhost monitor disk -h | grep  "usage: dsconf instance monitor disk" 
    CHECK_RESULT $? 0 0 "Check: backend monitor disk -h No Pass" 

    LOG_INFO "End to run testcase:oe_test_dsconf_backend."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsconf localhost chaining link-delete link1
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf change.sh
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
