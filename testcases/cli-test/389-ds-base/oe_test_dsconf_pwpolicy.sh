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
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export NSSLAPD_DB_LIB=bdb
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --create-entries --suffix dc=example,dc=com --be-name example
    dsidm -b "dc=example,dc=com" localhost user create --uid user_name --cn user_name --displayName user_name --uidNumber 1001 --gidNumber 1001 --homeDirectory /home/user_name
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost pwpolicy -h | grep  "usage: dsconf.*instance.*pwpolicy" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy -h No Pass" 
    dsconf localhost pwpolicy get -h | grep  "usage: dsconf.*instance.*pwpolicy get" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy get -h No Pass" 
    dsconf localhost pwpolicy get | grep  "Global Password Policy:" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy get No Pass" 
    dsconf localhost pwpolicy set -h | grep  "usage: dsconf.*instance.*pwpolicy set" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy set -h No Pass" 
    dsconf localhost pwpolicy set --pwdscheme sha512 --pwdchange on --pwdmustchange on --pwdhistory on --pwdhistorycount 5 --pwdadmin cn=admin,ou=users,dc=example,dc=com --pwdtrack on --pwdwarning 86400 --pwdexpire on --pwdmaxage 2592000 --pwdminage 3600 --pwdgracelimit 3 --pwdsendexpiring on --pwdlockout on --pwdunlock on --pwdlockoutduration 1800 --pwdmaxfailures 5 --pwdresetfailcount 900 --pwdchecksyntax on --pwdminlen 8 --pwdmindigits 1 --pwdminalphas 1 --pwdminuppers 1 --pwdminlowers 1 --pwdminspecials 1 --pwdmin8bits 1 --pwdmaxrepeats 2 --pwdpalindrome on --pwdmaxseq 3 --pwdmaxseqsets 2 --pwdmaxclasschars 2 --pwdmincatagories 2 --pwdmintokenlen 6 --pwdbadwords "secret password" --pwduserattrs "useremail cellphone" --pwddictcheck on --pwddictpath /path/to/customdict --pwdlocal on --pwdisglobal on --pwdallowhash on --pwpinheritglobal on | grep  "Successfully updated global password policy" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy set all No Pass" 
    dsconf localhost localpwp -h | grep  "usage: dsconf.*instance.*localpwp" 
    CHECK_RESULT $? 0 0 "Check: localpwp -h No Pass" 
    dsconf localhost localpwp addsubtree -h | grep  "usage: dsconf.*instance.*localpwp addsubtree" 
    CHECK_RESULT $? 0 0 "Check: localpwp addsubtree -h No Pass" 
    dsconf localhost localpwp addsubtree "ou=People,dc=example,dc=com" | grep  "Successfully created subtree password policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp addsubtree  No Pass" 
    dsconf localhost localpwp adduser -h | grep  "usage: dsconf.*instance.*localpwp adduser" 
    CHECK_RESULT $? 0 0 "Check: localpwp adduser -h No Pass" 
    dsconf localhost localpwp adduser "uid=user_name,ou=People,dc=example,dc=com"| grep  "Successfully created user password policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp adduser  No Pass" 
    dsconf localhost localpwp adduser -h | grep  "usage: dsconf.*instance.*localpwp adduser" 
    CHECK_RESULT $? 0 0 "Check: localpwp adduser -h No Pass" 
    dsconf localhost localpwp set --pwdmustchange on "uid=user_name,ou=People,dc=example,dc=com"| grep  "Successfully updated user policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp set --pwdmustchange No Pass" 
    dsconf localhost localpwp list -h | grep  "usage: dsconf.*instance.*localpwp list" 
    CHECK_RESULT $? 0 0 "Check: localpwp list -h No Pass" 
    dsconf localhost localpwp list | grep  "uid=user_name,ou=people,dc=example,dc=com (user policy)" 
    CHECK_RESULT $? 0 0 "Check: localpwp list No Pass"
    dsconf localhost localpwp remove -h | grep  "usage: dsconf.*instance.*localpwp remove" 
    CHECK_RESULT $? 0 0 "Check: localpwp remove -h No Pass" 
    dsconf localhost localpwp remove "ou=People,dc=example,dc=com" | grep  "Successfully deleted subtree policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp remove No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsconf localhost localpwp remove "uid=user_name,ou=People,dc=example,dc=com"
    echo "Yes I am sure" | dsidm -b "dc=example,dc=com" localhost user delete uid=user_name,ou=people,dc=example,dc=com
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"