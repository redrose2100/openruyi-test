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
    dsconf localhost schema -h | grep "usage: dsconf.* instance schema" 
    CHECK_RESULT $? 0 0 "Check: schema -h No Pass" 
    dsconf localhost schema list | grep "Objectclasses"
    CHECK_RESULT $? 0 0 "Check: list No Pass" 
    dsconf localhost schema list -h | grep "usage: dsconf.* instance schema list"
    CHECK_RESULT $? 0 0 "Check: list -h No Pass" 
    dsconf localhost schema attributetypes -h | grep "usage: dsconf.* instance schema attributetypes"
    CHECK_RESULT $? 0 0 "Check: attributetypes -h No Pass"
    dsconf localhost schema attributetypes get_syntaxes | grep Telex
    CHECK_RESULT $? 0 0 "Check: get_syntaxes No Pass" 
    dsconf localhost schema attributetypes get_syntaxes -h | grep "usage: dsconf.* instance schema attributetypes get_syntaxes"
    CHECK_RESULT $? 0 0 "Check: get_syntaxes -h No Pass" 
    dsconf localhost schema attributetypes list | grep "CACertExtractFile-oid"
    CHECK_RESULT $? 0 0 "Check: schema -h No Pass" 
    dsconf localhost schema attributetypes list -h | grep "usage: dsconf.* instance schema attributetypes list"
    CHECK_RESULT $? 0 0 "Check: schema -h No Pass" 
    dsconf localhost schema attributetypes query -h | grep "usage: dsconf.* instance schema attributetypes query"
    CHECK_RESULT $? 0 0 "Check: attributetypes query -h No Pass" 
    dsconf localhost schema attributetypes query FTPStatus | grep "FTPStatus"
    CHECK_RESULT $? 0 0 "Check: attributetypes query No Pass" 
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