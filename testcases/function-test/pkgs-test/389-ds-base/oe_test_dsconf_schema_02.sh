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
# @Author    :   liaoyuankun
# @Contact   :   1561203725@qq.com
# @Date      :   2023/8/31
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

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
    dsconf localhost schema attributetypes add --oid="2.16.840.1.1133730.2.1.123" --desc="For employee birthdays" --syntax="1.3.6.1.4.1.1466.115.121.1.15" --single-value --x-origin="Example defined" dateOfBirth | grep "Successfully added the attributeType"
    CHECK_RESULT $? 0 0 "Check:  attributetypes add No Pass"
    dsconf localhost schema attributetypes add -h | grep "usage: dsconf.* instance schema attributetypes add"
    CHECK_RESULT $? 0 0 "Check:  attributetypes add -h No Pass"
    dsconf localhost schema attributetypes replace -h | grep "usage: dsconf.* instance schema attributetypes replace"
    CHECK_RESULT $? 0 0 "Check:  attributetypes replace -h No Pass"
    dsconf localhost schema attributetypes replace --desc="desc been replaced" FTPStatus 2>&1| grep "Cannot delete a standard attribute type"
    CHECK_RESULT $? 0 0 "Check:  attributetypes replace -h No Pass"
    dsconf localhost schema attributetypes remove -h | grep "usage: dsconf.* instance schema attributetypes remove"
    CHECK_RESULT $? 0 0 "Check:  attributetypes remove -h No Pass"
    dsconf localhost schema attributetypes remove FTPStatus 2>&1| grep "standard attribute type"
    CHECK_RESULT $? 0 0 "Check:  attributetypes remove No Pass"
    dsconf localhost schema objectclasses -h | grep "usage: dsconf.* instance schema objectclasses" 
    CHECK_RESULT $? 0 0 "Check:  objectclasses -h No Pass" 
    dsconf localhost schema objectclasses list -h | grep "usage: dsconf.* instance schema objectclasses list"
    CHECK_RESULT $? 0 0 "Check: objectclasses list -h No Pass" 
    dsconf localhost schema objectclasses list | grep "LDAPServer"
    CHECK_RESULT $? 0 0 "Check: objectclasses list No Pass" 
    dsconf localhost schema objectclasses query LDAPServer | grep "LDAPServer"
    CHECK_RESULT $? 0 0 "Check: objectclasses query No Pass" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"