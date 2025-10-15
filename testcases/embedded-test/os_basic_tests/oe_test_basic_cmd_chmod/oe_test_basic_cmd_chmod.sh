#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-chmod
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    test -d /tmp/test01 && rm -rf /tmp/test01
    mkdir -p /tmp/test01/test02/test03

    mkdir -p /tmp/test02/test03
    touch /tmp/test02/test02.txt
    touch /tmp/test02/test03/test03.txt

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    output1=$(ls -l /tmp)
    echo "$output1" | grep "test01" | awk '{print $1}' | grep -e "drwxrwxrwx"
    CHECK_RESULT $? 1 0 "dir default mod is drwxrwxrwx"
    output2=$(ls -l /tmp/test01)
    per01=$(echo "$output2" | grep "test02" | awk '{print $1}')

    chmod 777 /tmp/test01
    output3=$(ls -l /tmp)
    echo "$output3" | grep "test01" | awk '{print $1}' | grep -e "drwxrwxrwx"
    CHECK_RESULT $? 0 0 "after chmod check /tmp/test01 mod fail"
    output4=$(ls -l /tmp/test01)
    per02=$(echo "$output4"  | grep "test02" | awk '{print $1}')
    [ "$per01" == "$per02" ]
    CHECK_RESULT $? 0 0 "check chmod only change one dir fail"

    chmod -R 777 /tmp/test01
    output5=$(ls -l /tmp)
    echo "$output5" | grep "test01" | awk '{print $1}' | grep -e "drwxrwxrwx"
    CHECK_RESULT $? 0 0 "check chmod -R change test01 mod fail"
    output6=$(ls -l /tmp/test01)
    echo "$output6" | grep "test02" | awk '{print $1}' | grep -e "drwxrwxrwx"
    CHECK_RESULT $? 0 0 "check chmod -R change test02 mod fail"

    chmod +x /tmp/test02/test03/test03.txt
    output7=$(ls -l /tmp/test02/test03)
    echo "$output7" | grep "test03.txt" | awk '{print $1}' | grep -e "rwxr-xr-x"
    CHECK_RESULT $? 0 0 "The access of /tmp/test02/test03/test03.txt is error."
    chmod u-x /tmp/test02/test03/test03.txt
    output8=$(ls -l /tmp/test02/test03)
    echo "$output8" | grep "test03.txt" | awk '{print $1}' | grep -e "rw-r-xr-x"
    CHECK_RESULT $? 0 0 "The access of /tmp/test02/test03/test03.txt is error."
    chmod o-w /tmp/test02/test03/test03.txt
    output9=$(ls -l /tmp/test02/test03)
    echo "$output9"  | grep "test03.txt" | awk '{print $1}' | grep -e "rw-r-xr-x"
    CHECK_RESULT $? 0 0 "The access of /tmp/test02/test03/test03.txt is error."

    chmod --help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "check chmod help fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /tmp/test01 /tmp/test02

    LOG_INFO "End to restore the test environment."
}

main "$@"
