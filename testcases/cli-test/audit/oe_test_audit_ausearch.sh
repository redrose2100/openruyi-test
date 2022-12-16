#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2022-12-16
# @License   :   Mulan PSL v2
# @Desc      :   Command audit ausearch
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd uos1
    chmod 755 /home/uos1
    su - uos1 -c "touch /home/uos1/testfile"   
    auditctl -w /home/uos1/testfile -p rwxa -k testfile_audit
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    ausearch --format csv
    CHECK_RESULT $? 0 0 "format check fail"   
    ausearch -m AVC
    CHECK_RESULT $? 0 0 "AVC check fail"   
    ausearch -ua uos1
    CHECK_RESULT $? 0 0 "ua check fail"   
    ausearch -f testfile
    CHECK_RESULT $? 0 0 "testfile check fail"  
    ausearch -k testfile_audit
    CHECK_RESULT $? 0 0 "testfile_audit check fail"   
    ausearch -sv yes 
    ausearch -sv no
    CHECK_RESULT $? 0 0 "sv check fail"  
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf uos1
    auditctl -D
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
