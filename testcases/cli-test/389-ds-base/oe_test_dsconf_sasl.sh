#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huxintao
# @Contact   :   806908118@qq.com
# @Date      :   2023/9/03
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost sasl -h | grep "usage: dsconf.* instance sasl"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl -h No Pass"
    dsconf localhost sasl list -h | grep "usage: dsconf.* instance sasl list"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl list -h No Pass"
    dsconf localhost sasl list | grep "Kerberos uid mapping"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl list No Pass"
    dsconf localhost sasl list --details | grep "Kerberos uid mapping"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl list --details No Pass"
    dsconf localhost sasl get-mechs -h | grep "usage: dsconf.* instance sasl get-mechs"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get-mechs -h No Pass"    
    dsconf localhost sasl get-mechs | grep "EXTERNAL"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get-mechs No Pass"
    dsconf localhost sasl get -h | grep "usage: dsconf.* instance sasl get"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get -h No Pass"
    dsconf localhost sasl get "rfc 2829 dn syntax" | grep "dn: cn=rfc 2829 dn syntax"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get No Pass"
    dsconf localhost sasl create -h | grep "usage: dsconf.* instance sasl create"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl create -h No Pass"
    dsconf localhost sasl create --cn=testuser --nsSaslMapRegexString=test0 --nsSaslMapBaseDNTemplate=test1 --nsSaslMapFilterTemplate=test2 --nsSaslMapPriority=1 | grep "Successfully created testuser"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl create No Pass"
    dsconf localhost sasl delete -h | grep "usage: dsconf.* instance sasl delete"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl delete -h No Pass"
	echo "Yes I am sure" | dsconf localhost sasl delete testuser | grep "Successfully deleted cn=testuser"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl delete No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dsctl localhost remove --do-it
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"