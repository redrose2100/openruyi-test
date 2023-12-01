#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/10
# @License   :   Mulan PSL v2
# @Desc      :   Test strust function
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "struts"
    mkdir /tmp/test
    cd /tmp/test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    wget https://mirrors.huaweicloud.com/kunpeng/archive/kunpeng_solution/bigdata/Tools/checkSo.zip
    unzip checkSo.zip
    test -e checkSo
    CHECK_RESULT $? 0 0 "Decompression failure"
    yum download struts
    cd checkSo/;chmod 755 *
    ./main.sh /tmp/test/struts*.rpm | grep 'unpack file /checkSo/tmp_unzip/struts';testtime=$(date)
    CHECK_RESULT $? 0 0 "Execution failure"
    [[ `cat JarResult.log |wc -l` -eq 0 ]]
    CHECK_RESULT $? 0 0 "Execution failure2"
    cat NonJarResult.log | grep "$testtime"
    CHECK_RESULT $? 0 0 "Execution failure3"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/test
    unset testtime
    LOG_INFO "End to restore the test environment."
}

main "$@"

