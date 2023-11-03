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
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test genders
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "genders tar"
    tar -xvf ./common/data.tar.gz  >  /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nodeattr 2>&1 | grep "Usage: nodeattr"
    CHECK_RESULT $? 0 0 "Check nodeattr failed"
    nodeattr -f ./data/genderfile -s web | grep "web-01 web-02"
    CHECK_RESULT $? 0 0 "Check nodeattr -f failed"
    nodeattr -f ./data/genderfile -s web | grep "web-01 web-02"
    CHECK_RESULT $? 0 0 "Check nodeattr -s failed"
    nodeattr -f ./data/genderfile -n web | grep "web-01"
    CHECK_RESULT $? 0 0 "Check nodeattr -n failed"
    nodeattr -f ./data/genderfile -c web | grep "web-01,web-02,"
    CHECK_RESULT $? 0 0 "Check nodeattr -c failed"
    nodeattr -f ./data/genderfile -q web | grep "web-\[01-04]"
    CHECK_RESULT $? 0 0 "Check nodeattr -q failed"
    nodeattr -f ./data/genderfile -s -A | grep "mail-10 web-01"
    CHECK_RESULT $? 0 0 "Check nodeattr -A failed"
    attr=$(nodeattr -f ./data/genderfile -s -A -X mail)
    test "${attr}" == "web-01 web-02 web-03 web-04"
    CHECK_RESULT $? 0 0 "Check nodeattr -X failed"
    nodeattr -f ./data/genderfile -v web-01 unix
    CHECK_RESULT $? 0 0 "Check nodeattr -v failed"
    nodeattr -f ./data/genderfile -Q web-01 web
    CHECK_RESULT $? 0 0 "Check nodeattr -Q failed"
    nodeattr -f ./data/genderfile -l web-01 | grep unix
    CHECK_RESULT $? 0 0 "Check nodeattr -l failed"
    nodeattr -f ./data/genderfile -d ./data/gender 2>&1 |  grep 'Contains additional node "cluster1"'
    CHECK_RESULT $? 0 0 "Check nodeattr -d failed"
    nodeattr -f ./data/genderfile --expand | grep "mail-01 mail,unix"
    CHECK_RESULT $? 0 0 "Check nodeattr --expand failed"
    nodeattr -f ./data/genderfile --compress | grep "mail-\[01-10],web-\[01-04]"
    CHECK_RESULT $? 0 0 "Check nodeattr --compress failed"
    nodeattr -f ./data/genderfile --compress-hosts | grep "mail-\[01-10] mail,unix"
    CHECK_RESULT $? 0 0 "Check nodeattr --compress-hosts failed"
    nodeattr -f ./data/genderfile -V web-01
    CHECK_RESULT $? 0 0 "Check nodeattr -V failed"
    nodeattr -f ./data/genderfile -V  -U web-01
    CHECK_RESULT $? 0 0 "Check nodeattr -U failed"
    nodeattr -f ./data/gender -k 2>&1 | grep "0 parse errors"
    CHECK_RESULT $? 0 0 "Check nodeattr -k failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
