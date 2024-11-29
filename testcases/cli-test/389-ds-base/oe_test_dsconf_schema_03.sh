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
    dsconf localhost schema objectclasses query -h | grep "usage: dsconf.*instance.*schema objectclasses query"
    CHECK_RESULT $? 0 0 "Check: objectclasses query -h No Pass"
    dsconf localhost schema objectclasses add -h | grep "usage: dsconf.*instance.*schema objectclasses add"
    CHECK_RESULT $? 0 0 "Check: objectclasses add -h No Pass"
    dsconf localhost schema objectclasses add --oid="2.16.840.1.1133730.2.1.99" --desc="An example person object class" --x-origin="Account Policy Plugin" --sup="top" --must="nsDS5ReplicaUpdateSchedule" examplePerson | grep -i "Successfully added the objectClass"
    CHECK_RESULT $? 0 0 "Check: objectclasses add No Pass"
    dsconf localhost schema objectclasses replace -h | grep "usage: dsconf.*instance.*schema objectclasses replace"
    CHECK_RESULT $? 0 0 "Check: objectclasses replace -h No Pass"
    dsconf localhost schema objectclasses replace examplePerson | grep "Successfully changed the objectClass"
    CHECK_RESULT $? 0 0 "Check: objectclasses replace No Pass"
    dsconf localhost schema objectclasses remove -h | grep "usage: dsconf.*instance.*schema objectclasses remove"
    CHECK_RESULT $? 0 0 "Check: objectclasses remove -h No Pass"
    dsconf localhost schema objectclasses remove examplePerson | grep "Successfully removed the objectClass"
    CHECK_RESULT $? 0 0 "Check: objectclasses remove No Pass"
    dsconf localhost schema matchingrules -h | grep "usage: dsconf.*instance.*schema matchingrules"
    CHECK_RESULT $? 0 0 "Check: matchingrules -h No Pass"
    dsconf localhost schema matchingrules list -h | grep "usage: dsconf.*instance.*schema matchingrules list"
    CHECK_RESULT $? 0 0 "Check: matchingrules list -h No Pass"
    dsconf localhost schema matchingrules list | grep "booleanMatch"
    CHECK_RESULT $? 0 0 "Check: matchingrules list No Pass"
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
