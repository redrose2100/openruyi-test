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
    dsidm -b "dc=example,dc=com" localhost initialise
    dsidm -b "dc=example,dc=com" localhost user create --uid user_name --cn user_name --displayName user_name --uidNumber 1001 --gidNumber 1001 --homeDirectory /home/user_name
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### pwpolicy -h
    dsconf localhost pwpolicy -h | grep  "usage: dsconf instance pwpolicy" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy -h No Pass" 
    ### pwpolicy get -h
    dsconf localhost pwpolicy get -h | grep  "usage: dsconf instance pwpolicy get" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy get -h No Pass" 
    ### pwpolicy get
    dsconf localhost pwpolicy get | grep  "Global Password Policy:" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy get No Pass" 
    ### pwpolicy set -h
    dsconf localhost pwpolicy set -h | grep  "usage: dsconf instance pwpolicy set" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy set -h No Pass" 
    ### pwpolicy set all
    dsconf localhost pwpolicy set --pwdscheme sha512 --pwdchange on --pwdmustchange on --pwdhistory on --pwdhistorycount 5 --pwdadmin cn=admin,ou=users,dc=example,dc=com --pwdtrack on --pwdwarning 86400 --pwdexpire on --pwdmaxage 2592000 --pwdminage 3600 --pwdgracelimit 3 --pwdsendexpiring on --pwdlockout on --pwdunlock on --pwdlockoutduration 1800 --pwdmaxfailures 5 --pwdresetfailcount 900 --pwdchecksyntax on --pwdminlen 8 --pwdmindigits 1 --pwdminalphas 1 --pwdminuppers 1 --pwdminlowers 1 --pwdminspecials 1 --pwdmin8bits 1 --pwdmaxrepeats 2 --pwdpalindrome on --pwdmaxseq 3 --pwdmaxseqsets 2 --pwdmaxclasschars 2 --pwdmincatagories 2 --pwdmintokenlen 6 --pwdbadwords "secret password" --pwduserattrs "useremail cellphone" --pwddictcheck on --pwddictpath /path/to/customdict --pwdlocal on --pwdisglobal on --pwdallowhash on --pwpinheritglobal on | grep  "Successfully updated global password policy" 
    CHECK_RESULT $? 0 0 "Check: pwpolicy set all No Pass" 
     ### localpwp -h
    dsconf localhost localpwp -h | grep  "usage: dsconf instance localpwp" 
    CHECK_RESULT $? 0 0 "Check: localpwp -h No Pass" 

    ### localpwp addsubtree -h
    dsconf localhost localpwp addsubtree -h | grep  "usage: dsconf instance localpwp addsubtree" 
    CHECK_RESULT $? 0 0 "Check: localpwp addsubtree -h No Pass" 
    ### localpwp addsubtree 
    dsconf localhost localpwp addsubtree "ou=People,dc=example,dc=com" | grep  "Successfully created subtree password policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp addsubtree  No Pass" 
    ### localpwp adduser -h
    dsconf localhost localpwp adduser -h | grep  "usage: dsconf instance localpwp adduser" 
    CHECK_RESULT $? 0 0 "Check: localpwp adduser -h No Pass" 
    ### localpwp adduser 
    dsconf localhost localpwp adduser "uid=user_name,ou=People,dc=example,dc=com"| grep  "Successfully created user password policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp adduser  No Pass" 
    ### localpwp set -h
    dsconf localhost localpwp adduser -h | grep  "usage: dsconf instance localpwp adduser" 
    CHECK_RESULT $? 0 0 "Check: localpwp adduser -h No Pass" 
    ### localpwp set --pwdmustchange
    dsconf localhost localpwp set --pwdmustchange on "uid=user_name,ou=People,dc=example,dc=com"| grep  "Successfully updated user policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp set --pwdmustchange No Pass" 

    ### localpwp list -h
    dsconf localhost localpwp list -h | grep  "usage: dsconf instance localpwp list" 
    CHECK_RESULT $? 0 0 "Check: localpwp list -h No Pass" 
    ### localpwp list -h
    dsconf localhost localpwp list | grep  "uid=user_name,ou=people,dc=example,dc=com (user policy)" 
    CHECK_RESULT $? 0 0 "Check: localpwp list No Pass"
    
    ### localpwp remove -h
    dsconf localhost localpwp remove -h | grep  "usage: dsconf instance localpwp remove" 
    CHECK_RESULT $? 0 0 "Check: localpwp remove -h No Pass" 
    ### localpwp remove
    dsconf localhost localpwp remove "ou=People,dc=example,dc=com" | grep  "Successfully deleted subtree policy" 
    CHECK_RESULT $? 0 0 "Check: localpwp remove No Pass"

    LOG_INFO "End to run testcase:oe_test_dsconf_backend."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    dsconf localhost localpwp remove "uid=user_name,ou=People,dc=example,dc=com"
    echo "Yes I am sure" | dsidm -b "dc=example,dc=com" localhost user delete uid=user_name,ou=people,dc=example,dc=com
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
