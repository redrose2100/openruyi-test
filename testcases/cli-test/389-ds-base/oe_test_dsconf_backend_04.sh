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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost backend config -h | grep  "usage: dsconf.* instance backend config" 
    CHECK_RESULT $? 0 0 "Check: backend config -h No Pass" 
    dsconf localhost backend config get -h | grep  "usage: dsconf.* instance backend config get" 
    CHECK_RESULT $? 0 0 "Check: backend config get -h No Pass" 
    dsconf localhost backend config set -h | grep  "usage: dsconf.* instance backend config set" 
    CHECK_RESULT $? 0 0 "Check: backend config set -h No Pass" 
    dsconf localhost backend config set --lookthroughlimit 100 | grep -iE  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --lookthroughlimit No Pass" 
    dsconf localhost backend config set --mode 0644 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --mode No Pass" 
    dsconf localhost backend config set --idlistscanlimit  100 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --idlistscanlimit  No Pass" 
    dsconf localhost backend config set --directory  /var/lib/dirsrv/slapd-localhost/db | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --directory  No Pass"
    dsconf localhost backend config set --txn-wait on | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-wait No Pass" 
    dsconf localhost backend config set --checkpoint-interval 60 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --checkpoint-interval No Pass" 
    dsconf localhost backend config set --compactdb-interval 2592000 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --compactdb-interval No Pass" 
    dsconf localhost backend config set --txn-batch-val 50 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-val No Pass" 
    dsconf localhost backend config set --txn-batch-min 50 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-min No Pass" 
    dsconf localhost backend config set --txn-batch-max 50 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-max No Pass" 
    dsconf localhost backend config set --locks 10000 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-max No Pass" 
    dsconf localhost backend config set --import-cache-autosize -1 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --import-cache-autosize No Pass" 
    dsconf localhost backend config set --cache-autosize 25 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --cache-autosize No Pass" 
    dsconf localhost backend config set --cache-autosize-split 25 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --cache-autosize-split No Pass" 
    dsconf localhost backend config set --import-cachesize 16777216 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --import-cachesize No Pass" 
    dsconf localhost backend config set --pagedlookthroughlimit 0 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --pagedlookthroughlimit No Pass" 
    dsconf localhost backend config set --pagedidlistscanlimit 0 | grep -iE  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --pagedidslistscanlimit No Pass" 
    dsconf localhost backend config set --rangelookthroughlimit 5000 | grep -iE  "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --rangelookthroughlimit No Pass" 
    dsconf localhost backend config set --deadlock-policy 9 | grep -iE "Successfully updated database configuration" 
    CHECK_RESULT $? 0 0 "Check: backend config set --deadlock-policy No Pass" 
    dsconf localhost backend monitor -h | grep  "usage: dsconf.* instance backend monitor" 
    CHECK_RESULT $? 0 0 "Check: backend monitor -h No Pass" 
    dsconf localhost backend monitor --suffix example | grep  "dn: cn=monitor" 
    CHECK_RESULT $? 0 0 "Check: monitor --suffix No Pass"
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