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
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    ## indexDN=dc=exmaple,dc=com   databse=example
    dsconf localhost backend create --index dc=example,dc=com --be-name example
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### index
    dsconf localhost backend index -h | grep  "usage: dsconf instance backend index" 
    CHECK_RESULT $? 0 0 "Check: backend index -h No Pass" 
    ### add -h
    dsconf localhost backend index add  -h | grep  "usage: dsconf instance backend index add" 
    CHECK_RESULT $? 0 0 "Check: backend index add -h No Pass" 
    ### add --index-type 
    dsconf localhost backend index add --index-type eq --attr name example | grep  "Successfully added index" 
    CHECK_RESULT $? 0 0 "Check: backend index add --index-type  No Pass" 
    dsconf localhost backend index delete --attr name example
    ### add --matching-rule
    dsconf localhost backend index add --index-type eq --matching-rule eqality --attr name example | grep  "Successfully added index" 
    CHECK_RESULT $? 0 0 "Check: backend index add --matching-rule No Pass" 
    dsconf localhost backend index delete --attr name example
    ### add --reindex
    dsconf localhost backend index add --index-type eq --matching-rule equality --reindex --attr name example| grep  "completed successfully" 
    CHECK_RESULT $? 0 0 "Check: backend index --reindex No Pass" 
    ### set -h
    dsconf localhost backend index set -h| grep  "usage: dsconf instance backend index set" 
    CHECK_RESULT $? 0 0 "Check: backend index set -h No Pass" 
    ### set --add-type
    dsconf localhost backend index set --attr name --add-type sub example| grep  "Index successfully updated" 
    CHECK_RESULT $? 0 0 "Check: backend index set --add-type No Pass" 
    ### set --del-type
    dsconf localhost backend index set --attr name --del-type sub example| grep  "Index successfully updated" 
    CHECK_RESULT $? 0 0 "Check: backend index set --del-type No Pass" 
    ### set --add-mr
    dsconf localhost backend index set --attr name --add-mr ordering example | grep  "Index successfully updated" 
    CHECK_RESULT $? 0 0 "Check: backend index set --add-mrx No Pass" 
    ### set --add-mr
    dsconf localhost backend index set --attr name --del-mr ordering example | grep  "Index successfully updated" 
    CHECK_RESULT $? 0 0 "Check: backend index set --add-mr No Pass" 
    ### set --reindex
    dsconf localhost backend index set --attr name --reindex example | grep  "Index successfully updated" 
    CHECK_RESULT $? 0 0 "Check: backend index aset --reindex No Pass" 
    ### get -h
    dsconf localhost backend index get -h| grep  "usage: dsconf instance backend index get" 
    CHECK_RESULT $? 0 0 "Check: backend index get -h No Pass" 
    ### get --attr
    dsconf localhost backend index get --attr name example| grep  "cn: name" 
    CHECK_RESULT $? 0 0 "Check: backend index get --attr No Pass" 

    ### list -h
    dsconf localhost backend index list -h| grep  "usage: dsconf instance backend index list" 
    CHECK_RESULT $? 0 0 "Check: backend index list -h No Pass" 
    ### list --just-names
    dsconf localhost backend index list --just-names example| grep  "name" 
    CHECK_RESULT $? 0 0 "Check: backend index list --just-names No Pass" 
    ### delete -h
    dsconf localhost backend index delete -h | grep  "usage: dsconf instance backend index delete" 
    CHECK_RESULT $? 0 0 "Check: backend index delete -h No Pass" 
    

    ###reindex -h
    dsconf localhost backend index reindex -h | grep  "usage: dsconf instance backend index reindex" 
    CHECK_RESULT $? 0 0 "Check: backend index reindex -h No Pass"
    ###reindex --attr
    dsconf localhost backend index reindex --attr name example | grep  "Successfully reindexed database" 
    CHECK_RESULT $? 0 0 "Check: backend index reindex --attr No Pass"
    ###reindex --wait
    dsconf localhost backend index reindex --wait example | grep  "Successfully reindexed database" 
    CHECK_RESULT $? 0 0 "Check: backend index reindex --wait No Pass"

    ### delete --attr
    dsconf localhost backend index delete --attr name example | grep  "Successfully deleted index" 
    CHECK_RESULT $? 0 0 "Check: backend index delete --attr No Pass" 

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
