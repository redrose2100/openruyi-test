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
    ### config -h
    dsconf localhost backend config -h | grep  "usage: dsconf instance backend config" 
    CHECK_RESULT $? 0 0 "Check: backend config -h No Pass" 
    ### get -h
    dsconf localhost backend config get -h | grep  "usage: dsconf instance backend config get" 
    CHECK_RESULT $? 0 0 "Check: backend config get -h No Pass" 
    ### set -h
    dsconf localhost backend config set -h | grep  "usage: dsconf instance backend config set" 
    CHECK_RESULT $? 0 0 "Check: backend config set -h No Pass" 
    ### set --lookthroughlimit
    dsconf localhost backend config set --lookthroughlimit 100 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --lookthroughlimit No Pass" 
    ### set --mode
    dsconf localhost backend config set --mode 0644 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --mode No Pass" 
    ### set --idlistscanlimit 
    dsconf localhost backend config set --idlistscanlimit  100 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --idlistscanlimit  No Pass" 
    ### set --directory
    dsconf localhost backend config set --directory  /var/lib/dirsrv/slapd-localhost/db | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --directory  No Pass"
    ### set --dbcachesize
    #dsconf localhost backend config set --dbcachesize  100 | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --dbcachesize  No Pass"
    ### set --logdirectory
    #dsconf localhost backend config set --logdirectory /var/lib/dirsrv/slapd-localhost/db | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --logdirectory No Pass" 
    ### set --durable-txn
    #dsconf localhost backend config set --durable-txn on | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --durable-txn No Pass" 
    ### set --txn-wait
    dsconf localhost backend config set --txn-wait on | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-wait No Pass" 
    ### set --checkpoint-interval
    dsconf localhost backend config set --checkpoint-interval 60 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --checkpoint-interval No Pass" 
    ### set --compactdb-interval
    dsconf localhost backend config set --compactdb-interval 2592000 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --compactdb-interval No Pass" 
    ### set --txn-batch-val
    dsconf localhost backend config set --txn-batch-val 50 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-val No Pass" 
    ### set --txn-batch-min
    dsconf localhost backend config set --txn-batch-min 50 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-min No Pass" 
    ### set --txn-batch-max
    dsconf localhost backend config set --txn-batch-max 50 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-max No Pass" 
    ### set --logbufsize
    #dsconf localhost backend config set --logbufsize 0 | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --logbufsize No Pass"
    ### set --locks
    dsconf localhost backend config set --locks 10000 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-max No Pass" 
    ### set --import-cache-autosize
    dsconf localhost backend config set --import-cache-autosize -1 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --import-cache-autosize No Pass" 
    ### set --cache-autosize
    dsconf localhost backend config set --cache-autosize 25 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --cache-autosize No Pass" 
    ### set --cache-autosize-split
    dsconf localhost backend config set --cache-autosize-split 25 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --cache-autosize-split No Pass" 
    ### set --import-cachesize
    dsconf localhost backend config set --import-cachesize 16777216 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --import-cachesize No Pass" 
    

    ### set --exclude-from-export
    #dsconf localhost backend config set --exclude-from-export 16777216 | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --exclude-from-export No Pass" 
    ### set --pagedlookthroughlimit
    dsconf localhost backend config set --pagedlookthroughlimit 0 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --pagedlookthroughlimit No Pass" 
    ### set --pagedidslistscanlimit
    dsconf localhost backend config set --pagedidlistscanlimit 0 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --pagedidslistscanlimit No Pass" 
    ### set --rangelookthroughlimit
    dsconf localhost backend config set --rangelookthroughlimit 5000 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --rangelookthroughlimit No Pass" 
    ### set --backend-opt-level
    #dsconf localhost backend config set --backend-opt-level 1 | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --backend-opt-level No Pass" 
    ### set --deadlock-policy
    dsconf localhost backend config set --deadlock-policy 9 | grep  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --deadlock-policy No Pass" 
    ### set --db-home-directory
    #dsconf localhost backend config set --db-home-directory 9 | grep  "Successfully updated database configuration" 
    #CHECK_RESULT $? 0 0 "Check: backend config set --db-home-directory No Pass" 

    ### monitor -h
    dsconf localhost backend monitor -h | grep  "usage: dsconf instance backend monitor" 
    CHECK_RESULT $? 0 0 "Check: backend monitor -h No Pass" 
    ### monitor --suffix
    dsconf localhost backend monitor --suffix example | grep  "dn: cn=monitor" 
    CHECK_RESULT $? 0 0 "Check: monitor --suffix No Pass" 
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
