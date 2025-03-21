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
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export NSSLAPD_DB_LIB=bdb
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    cat << EOF > users.ldif
    dn: cn=John Doe,ou=Users,dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: John Doe
    givenName: John
    sn: Doe
    uid: jdoe
    userPassword: {SHA}nApd9DdVmI4lVu+8vFd/KkcSqJA=
    mail: jdoe@example.com
    telephoneNumber: +1 555 1234567
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: Jane Smith
    givenName: Jane
    sn: Smith
    uid: jsmith
    userPassword: {SHA}GRZrkyT82ZB6Tsll+3MRiObGtl4=
    mail: jsmith@example.com
    telephoneNumber: +1 555 9876543
EOF

    cp users.ldif /var/lib/dirsrv/slapd-localhost/ldif/users.ldif
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost backend import -h | grep  "usage: dsconf.*instance.*backend import" 
    CHECK_RESULT $? 0 0 "Check: backend import -h No Pass" 
    dsconf localhost backend import -c 2 example user.ldif 2>&1| grep  "'int' object has no attribute 'encode'" 
    CHECK_RESULT $? 0 0 "Check: backend import -h No Pass" 
    dsconf localhost backend import -E example users.ldif | grep  "The import task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend import -E No Pass" 
    dsconf localhost backend import -O example users.ldif | grep  "The import task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend import -O No Pass" 
    dsconf localhost backend export -h | grep  "usage: dsconf.*instance.*backend export" 
    CHECK_RESULT $? 0 0 "Check: backend export -h No Pass" 
    dsconf localhost backend export -l a.ldif example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -l No Pass" 
    dsconf localhost backend export -C example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -C No Pass" 
    dsconf localhost backend export -E example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -E No Pass" 
    dsconf localhost backend export -m example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -m No Pass"
    dsconf localhost backend export -N example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -N No Pass"
    dsconf localhost backend export -r example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -r No Pass"
    dsconf localhost backend export -u example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -u No Pass"
    dsconf localhost backend export -U example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -U No Pass"
    dsconf localhost backend create -h  | grep  "usage: dsconf.*instance.*backend create" 
    CHECK_RESULT $? 0 0 "Check: backend create -h No Pass" 
    dsconf localhost backend create --parent-suffix dc=com --suffix dc=exa,dc=com --be-name example2  | grep  "The database was successfully created" 
    CHECK_RESULT $? 0 0 "Check: backend create -h No Pass"
    dsconf localhost backend delete -h  | grep  "usage: dsconf.*instance.*backend delete" 
    CHECK_RESULT $? 0 0 "Check: backend delete -h No Pass" 
    if [ "$(rpm -qa 389-ds-base | awk -F- '{print $4}' | awk -F. '{print $1}')" -ge 3 ]; then
        (echo "Yes I am sure" | dsconf localhost backend delete --do-it example2) | grep "were successfully deleted"
    else
        (echo "Yes I am sure" | dsconf localhost backend delete example2) | grep "were successfully deleted"
    fi
    dsconf localhost backend get-tree -h | grep  "usage: dsconf.*instance.*backend get-tree" 
    CHECK_RESULT $? 0 0 "Check: backend get-tree -h No Pass" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /var/lib/dirsrv/slapd-localhost/ldif/* users.ldif 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"