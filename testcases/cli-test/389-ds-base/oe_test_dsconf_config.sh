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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost config -h | grep  "usage: dsconf.* instance config" 
    CHECK_RESULT $? 0 0 "Check: config -h No Pass" 
    dsconf localhost config get -h | grep  "usage: dsconf.* instance config get" 
    CHECK_RESULT $? 0 0 "Check: config get -h No Pass" 
    dsconf localhost config get  | grep  "dn: cn=config" 
    CHECK_RESULT $? 0 0 "Check: config get  No Pass" 
    dsconf localhost config add -h | grep  "usage: dsconf.* instance config add" 
    CHECK_RESULT $? 0 0 "Check: config add -h No Pass" 
    dsconf localhost config replace -h | grep  "usage: dsconf.* instance config replace" 
    CHECK_RESULT $? 0 0 "Check: config replace -h No Pass" 
    dsconf localhost config delete -h | grep  "usage: dsconf.* instance config delete" 
    CHECK_RESULT $? 0 0 "Check: config delete -h No Pass" 
    dsconf -v localhost config delete nsslapd-accesslog-mode  | grep "successful" 
    CHECK_RESULT $? 0 0 "Check: config get  No Pass" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"