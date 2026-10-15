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
# @Date      :   2023/8/29
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
    export NSSLAPD_DB_LIB=bdb
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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost directory_manager -h | grep  "usage: dsconf.*instance.*directory_manager" 
    CHECK_RESULT $? 0 0 "Check: backend directory_manager -h No Pass" 
    dsconf localhost directory_manager password_change -h | grep  "usage: dsconf.*instance.*directory_manager password_change" 
    CHECK_RESULT $? 0 0 "Check: backend directory_manager password_change -h No Pass"
    bash ./change.sh 
    CHECK_RESULT $? 0 0 "Check: backend directory_manager password_change  No Pass"
    dsconf localhost monitor -h | grep  "usage: dsconf.*instance.*monitor" 
    CHECK_RESULT $? 0 0 "Check: backend monitor -h No Pass" 
    dsconf localhost monitor server -h | grep  "usage: dsconf.*instance.*monitor server" 
    CHECK_RESULT $? 0 0 "Check: backend monitor server-h No Pass" 
    dsconf localhost monitor dbmon -h | grep  "usage: dsconf.*instance.*monitor dbmon" 
    CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -h No Pass" 
    dsconf localhost monitor dbmon -b example | grep -iE "DB Monitor Report" 
    CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -b No Pass" 
    dsconf localhost monitor dbmon -b example -x | grep  "Indexes:" 
    CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -x No Pass" 
    dsconf localhost monitor ldbm -h | grep  "usage: dsconf.*instance.*monitor ldbm" 
    CHECK_RESULT $? 0 0 "Check: backend monitor ldbm -h No Pass" 
    dsconf localhost monitor backend -h | grep  "usage: dsconf.*instance.*monitor backend" 
    CHECK_RESULT $? 0 0 "Check: backend monitor backend -h No Pass" 
    dsconf localhost monitor backend example | grep  "dn: cn=monitor,cn=example,cn=ldbm database,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: backend monitor backend [backend] No Pass" 
    dsconf localhost monitor snmp -h | grep  "usage: dsconf.*instance.*monitor snmp" 
    CHECK_RESULT $? 0 0 "Check: backend monitor snmp -h No Pass" 
    dsconf localhost monitor chaining -h | grep  "usage: dsconf.*instance.*monitor chaining" 
    CHECK_RESULT $? 0 0 "Check: backend monitor chaining -h No Pass" 
    dsconf localhost monitor chaining link1 | grep  "dn: cn=monitor,cn=link1,cn=chaining database,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: backend monitor chaining [backend] No Pass" 
    dsconf localhost monitor disk -h | grep  "usage: dsconf.*instance.*monitor disk" 
    CHECK_RESULT $? 0 0 "Check: backend monitor disk -h No Pass" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsconf localhost chaining link-delete link1
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf change.sh -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"