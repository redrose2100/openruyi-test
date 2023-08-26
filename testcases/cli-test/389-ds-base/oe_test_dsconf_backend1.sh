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
    ## suffixDN=dc=exmaple,dc=com   databse=example
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### suffix
    dsconf localhost backend suffix -h | grep  "usage: dsconf instance backend suffix" 
    CHECK_RESULT $? 0 0 "Check: backend suffix list No Pass" 
    ### list -h
    dsconf localhost backend suffix list  -h | grep  "usage: dsconf instance backend suffix list" 
    CHECK_RESULT $? 0 0 "Check: backend suffix list No Pass" 
    ### list --suffix
    dsconf localhost backend suffix list --suffix | grep  -E "dc|ou|cn|No backends" 
    CHECK_RESULT $? 0 0 "Check: backend suffix list -suffix No Pass" 
    ### list --skip-subsuffixes
    dsconf localhost backend suffix list --skip-subsuffixes | grep  -E "dc|ou|cn|no backends" 
    CHECK_RESULT $? 0 0 "Check: backend suffix list -skip-subsuffixes No Pass" 
    ### get -h
    dsconf localhost backend suffix get -h | grep  "usage: dsconf instance backend suffix get"
    CHECK_RESULT $? 0 0 "Check: backend suffix get -h No Pass" 
    ### get 
    dsconf localhost backend suffix get  dc=example,dc=com | grep  "cn: example"
    CHECK_RESULT $? 0 0 "Check: backend suffix get selector No Pass" 
    ### get-dn -h
     dsconf localhost backend suffix get-dn -h  | grep  "usage: dsconf instance backend suffix get-dn"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-dn -h No Pass" 
    ### get-dn dn
    dsconf localhost backend suffix get-dn  "cn=example,cn=ldbm database,cn=plugins,cn=config" | grep  "cn: example"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-dn dn No Pass" 
    ### get-sub-suffixes  -h
     dsconf localhost backend suffix get-sub-suffixes -h  | grep  "usage: dsconf instance backend suffix get-sub-suffixes"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-sub-suffixes -h No Pass" 
    ### get-sub-suffixes   --suffix
    dsconf localhost backend suffix get-sub-suffixes --suffix  example | grep  "No sub-suffixes under this backend"
    CHECK_RESULT $? 0 0 "Check: backend suffix get-sub-suffixes --suffix No Pass" 
    
    ### set  -h
     dsconf localhost backend suffix set -h  | grep  "usage: dsconf instance backend suffix set"
    CHECK_RESULT $? 0 0 "Check: backend suffix set No Pass" 
    ### set  --enable-readonly
     dsconf localhost backend suffix set example --enable-readonly  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --enable-readonly No Pass" 
    ### set  --disable-readonly
     dsconf localhost backend suffix set example --disable-readonly  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --disable-readonly No Pass" 
    ### set  --required-index
    dsconf localhost backend suffix set example --require-index  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --required-index No Pass" 
    ### set  --ignore-index
    dsconf localhost backend suffix set example --ignore-index  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --ignore-index No Pass" 
    ### set  --add-referral
     dsconf localhost backend suffix set example --add-referral ou=eve  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --add-referral No Pass" 
    ### set  --del-referral
     dsconf localhost backend suffix set example --del-referral ou=eve  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --del-referral No Pass" 
     ### set  --enable
     dsconf localhost backend suffix set example --enable | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --enable No Pass" 
    ### set  --disable
     dsconf localhost backend suffix set example --disable  | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --disable No Pass" 

     ### set  --cache-size
    #dsconf localhost backend suffix set example --cache-size 100 | grep  ""nsslapd-cachesize" can not be updated while "nsslapd-cache-autosize" is set in "cn=config,cn=ldbm database,cn=plugins,cn=config""
    #CHECK_RESULT $? 0 0 "Check: backend suffix set  --cache-size No Pass" 
    ### set  --cache-memsize
    #dsconf localhost backend suffix set example --cache-memsize 100 | grep  ""nsslapd-cachememsize" can not be updated while "nsslapd-cache-autosize" is set in "cn=config,cn=ldbm database,cn=plugins,cn=config""
    #CHECK_RESULT $? 0 0 "Check: backend suffix set  --cache-memsize No Pass" 
    ### set  --dncache-memsize
    dsconf localhost backend suffix set example --dncache-memsize 100 | grep  "The backend configuration was successfully updated"
    CHECK_RESULT $? 0 0 "Check: backend suffix set  --dncache-memsize No Pass" 


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
