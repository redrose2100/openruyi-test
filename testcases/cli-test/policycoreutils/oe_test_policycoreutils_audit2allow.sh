#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test audit2allow
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "policycoreutils-python-utils"
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    audit2allow --version 
    CHECK_RESULT $? 0 0 "failed to show program's version number"
    audit2allow -h
    CHECK_RESULT $? 0 0 "failed to show this help message"
    audit2allow -a |grep "policy"
    CHECK_RESULT $? 0 0 "failed to check"
    audit2allow -a -M mypolicy
    CHECK_RESULT $? 0 0 "failed to builed"
    auditd
    audit2allow -w -a |grep 'type' 
    CHECK_RESULT $? 0 0 "failed to translates SELinux audit messages into a description"
    audit2allow -i /var/log/audit/audit.log -o /tmp/log
    CHECK_RESULT $? 0 0 "failed to append output"
    audit2allow -p |grep "policy"
    CHECK_RESULT $? 0 0 "failed to check"
    audit2allow -e -a 
    CHECK_RESULT $? 0 0 "failed to fully explain generated output"
    audit2allow -d
    CHECK_RESULT $? 0 0 "failed to read input from dmesg"
    audit2allow -b 
    CHECK_RESULT $? 0 0 "failed to audit messages since last boot conflicts with -i"
    audit2allow -l -i /var/log/messages|grep "allow"
    CHECK_RESULT $? 0 0 "failed to read input only after the last reload"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    test -f mypolicy* && rm -fr mypolicy*
    test -f /tmp/log && rm -rf /tmp/log
    LOG_INFO "End to restore the test environment."
}
main "$@"
