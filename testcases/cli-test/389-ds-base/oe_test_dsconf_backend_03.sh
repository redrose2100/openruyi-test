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
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    dsconf localhost backend create --index dc=example,dc=com --be-name example
    dsconf localhost backend vlv-index add-search --name my_vlv_search --search-base "dc=example,dc=com" --search-scope 2 --search-filter "(objectClass=person)" example 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost backend vlv-index -h | grep  "usage: dsconf.*instance.*backend vlv-index" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index -h No Pass" 
    dsconf localhost backend vlv-index list -h | grep  "usage: dsconf.*instance.*backend vlv-index list" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index list -h No Pass" 
    dsconf localhost backend vlv-index list --just-names example| grep  "my_vlv_search" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index list --just-names  No Pass" 
    dsconf localhost backend vlv-index get -h | grep  "usage: dsconf.*instance.*backend vlv-index get" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index get -h No Pass" 
    dsconf localhost backend vlv-index get --name my_vlv_search example | grep  "my_vlv_search" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index get --name  No Pass" 
    dsconf localhost backend vlv-index del-search --name my_vlv_search example
    dsconf localhost backend vlv-index add-search -h | grep  "usage: dsconf.*instance.*backend vlv-index add-search" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index add-search -h  No Pass" 
    dsconf localhost backend vlv-index add-search --name my_vlv_search --search-base "dc=example,dc=com" --search-scope 2 --search-filter "(objectClass=person)" example | grep  "Successfully created new VLV Search entry" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index --just-names  No Pass" 
    dsconf localhost backend vlv-index edit-search -h | grep  "usage: dsconf.*instance.*backend vlv-index edit-search" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search -h  No Pass"
    dsconf localhost backend vlv-index edit-search --name my_vlv_search --search-base "dc=example,dc=com" example| grep -iE  "Successfully updated VLV search entry" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search --search-base  No Pass" 
    dsconf localhost backend vlv-index edit-search --name my_vlv_search --search-scope 0 example| grep -iE  "Successfully updated VLV search entry" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search --search-scope  No Pass" 
    dsconf localhost backend vlv-index edit-search --name my_vlv_search --search-filter "(objectClass=top)" example| grep -iE "Successfully updated VLV search entry" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search --search-scope  No Pass" 
    dsconf localhost backend vlv-index add-index -h | grep  "usage: dsconf.*instance.*backend vlv-index add-index" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index add-index -h  No Pass"
    dsconf localhost backend vlv-index  add-index --parent-name my_vlv_search --index-name my_vlv_index --sort "sn givenName" example| grep -iE "Successfully created new VLV index entry" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index add-index --parent-name --index-name --sort  No Pass" 
    dsconf localhost backend vlv-index reindex -h | grep  "usage: dsconf.*instance.*backend vlv-index reindex" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index reindex -h  No Pass"
    dsconf localhost backend vlv-index reindex --parent-name my_vlv_search example| grep -iE "Successfully reindexed VLV indexes" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index reindex -h  No Pass"
    dsconf localhost backend vlv-index reindex --index-name my_vlv_index --parent-name my_vlv_search example| grep -iE "Successfully reindexed VLV indexes" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index reindex -h  No Pass"
    dsconf localhost backend vlv-index  del-index --parent-name my_vlv_search --index-name my_vlv_index --sort "sn givenName"  example| grep -iE  "Successfully deleted VLV index entry" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index del-index --parent-name --index-name --sort  No Pass" 
    dsconf localhost backend vlv-index del-search -h | grep  "usage: dsconf.*instance.*backend vlv-index del-search" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index del-search -h  No Pass" 
    dsconf localhost backend vlv-index del-search --name my_vlv_search example 2>&1 | grep -iE "Successfully deleted VLV search and its indexes" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index --just-names  No Pass" 
    dsconf localhost backend attr-encrypt -h | grep  "usage: dsconf.*instance.*backend attr-encrypt" 
    CHECK_RESULT $? 0 0 "Check: backend attr-encrypt -h  No Pass" 
    dsconf localhost backend attr-encrypt --add-attr name example  | grep -iE "Successfully added encrypted attribute" 
    CHECK_RESULT $? 0 0 "Check: backend attr-encrypt --add-attr  No Pass" 
    dsconf localhost backend attr-encrypt --list example  | grep  "cn: name" 
    CHECK_RESULT $? 0 0 "Check: backend attr-encrypt --list  No Pass" 
    dsconf localhost backend attr-encrypt --list --just-names example  | grep  "name" 
    CHECK_RESULT $? 0 0 "Check: backend attr-encrypt --just-names  No Pass" 
    dsconf localhost backend attr-encrypt --del-attr  name example | grep -iE "Successfully deleted encrypted attribute" 
    CHECK_RESULT $? 0 0 "Check: backend vlv-index --just-names  No Pass" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
