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
    dsconf localhost schema matchingrules query booleanMatch | grep "2.5.13.13"
    CHECK_RESULT $? 0 0 "Check: matchingrules query No Pass" 
    dsconf localhost schema matchingrules query -h | grep "usage: dsconf.* instance schema matchingrules query"
    CHECK_RESULT $? 0 0 "Check: matchingrules query -h No Pass" 
    dsconf localhost schema reload -h | grep "usage: dsconf.* instance schema reload"
    CHECK_RESULT $? 0 0 "Check: reload -h No Pass"
    dsconf localhost schema reload --wait | grep "successfully finished"
    CHECK_RESULT $? 0 0 "Check: reload --wait No Pass"
    dsconf localhost schema validate-syntax -h | grep "usage: dsconf.*instance.*schema validate-syntax"
    CHECK_RESULT $? 0 0 "Check: validate-syntax -h No Pass"
    dsconf localhost --verbose schema validate-syntax -f="FTPStatus" cn=example 2>&1 | grep "check logs"
    CHECK_RESULT $? 0 0 "Check: validate-syntax -f No Pass" 
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