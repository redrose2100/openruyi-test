#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2022-12-15
# @License   :   Mulan PSL v2
# @Desc      :   package mtools test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL mtools
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    yum list mtools
    CHECK_RESULT $? 0 0 "yum list mtools Toolkit not found"
    rpm -qa |grep mtools
    CHECK_RESULT $? 0 0 "rpm -qa |grep mtools You can find the mtools related toolkit name" 
    yum install mtools -y
    CHECK_RESULT $? 0 0 "mtools Toolkit download failed"
    rpm -qa |grep mtools
    CHECK_RESULT $? 0 0 "mtools Unable to query the mtools related toolkit name and specific version"
    rpm -ql mtools
    CHECK_RESULT $? 0 0 "mtools The mtools installation path cannot be queried"
    yum remove mtools -y
    CHECK_RESULT $? 0 0 "mtools The mtools Software package uninstallation failed"
    rpm -qa |grep mtools
    CHECK_RESULT $? 0 1 "mtools The software package can be found"
    LOG_INFO "Finish test!"
}

main $@

