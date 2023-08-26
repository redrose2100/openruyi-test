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
    #生成users.ldif文件
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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### import -h
    dsconf localhost backend import -h | grep  "usage: dsconf instance backend import" 
    CHECK_RESULT $? 0 0 "Check: backend import -h No Pass" 
    ### -c
    #dsconf localhost backend import -c 2 example user.ldif| grep  "'int'object has no attribute encode " 
    #CHECK_RESULT $? 0 0 "Check: backend import -h No Pass" 
    ### -E
    dsconf localhost backend import -E example users.ldif | grep  "The import task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend import -E No Pass" 
    ### -O
    dsconf localhost backend import -O example users.ldif | grep  "The import task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend import -O No Pass" 

    ###
    dsconf localhost backend export -h | grep  "usage: dsconf instance backend export" 
    CHECK_RESULT $? 0 0 "Check: backend export -h No Pass" 
    ### export -l
    dsconf localhost backend export -l a.ldif example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -l No Pass" 
    ### export -C
    dsconf localhost backend export -C example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -C No Pass" 
    ### export -E
    dsconf localhost backend export -E example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -E No Pass" 
    ### export -m
    dsconf localhost backend export -m example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -m No Pass"
    ### export -N
    dsconf localhost backend export -N example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -N No Pass"
    ### export -r
    dsconf localhost backend export -r example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -r No Pass"
    ### export -u
    dsconf localhost backend export -u example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -u No Pass"
    ### export -U
    dsconf localhost backend export -U example | grep  "The export task has finished successfully" 
    CHECK_RESULT $? 0 0 "Check: backend export -U No Pass"
    ### create -h
    dsconf localhost backend create -h  | grep  "usage: dsconf instance backend create" 
    CHECK_RESULT $? 0 0 "Check: backend create -h No Pass" 
    ### create --parent-suffix  --suffix --be-name --create-entries  --create-suffix
    #dsconf localhost backend create --parent-suffix dc=com --suffix dc=exa,dc=com --be-name example2 --create-entries --create-suffix | grep  "The database was successfully created" 
    #CHECK_RESULT $? 0 0 "Check: backend create -h No Pass"
    ### create --suffix --be-name
    dsconf localhost backend create --parent-suffix dc=com --suffix dc=exa,dc=com --be-name example2  | grep  "The database was sucessfully created" 
    CHECK_RESULT $? 0 0 "Check: backend create -h No Pass"

    ### delete -h
    dsconf localhost backend delete -h  | grep  "usage: dsconf instance backend delete" 
    CHECK_RESULT $? 0 0 "Check: backend delete -h No Pass" 
    ### delete 
    (echo "Yes I am sure" | dsconf localhost backend delete example2) | grep "were sucessfully deleted" 
    CHECK_RESULT $? 0 0 "Check: backend delete  No Pass" 
    ### get-tree -h
    dsconf localhost backend get-tree -h | grep  "usage: dsconf instance backend get-tree" 
    CHECK_RESULT $? 0 0 "Check: backend get-tree -h No Pass" 

    LOG_INFO "End to run testcase:oe_test_dsconf_backend."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /var/lib/dirsrv/slapd-localhost/ldif/*
    rm -rf users.ldif
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
