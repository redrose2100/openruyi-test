#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   yangyuangan
#@Contact       :   yangyuangan@uniontech.com
#@Date          :   2026/6/23
#@License       :   Mulan PSL v2
#@Desc          :   bash getfattr formatted test
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "This is a test for getfattr" > test_getfattr.txt
    setfattr -n user.test_getfattr -v "test_getfattr" test_getfattr.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    getfattr -d test_getfattr.txt
    CHECK_RESULT $? 0 0 "getfattr execute error"
    res1=$(getfattr -d test_getfattr.txt)
    echo "$res1" | grep -q 'user.test_getfattr="test_getfattr"'
    CHECK_RESULT $? 0 0 "getfattr -d query error"
    getfattr -n user.test_getfattr test_getfattr.txt
    CHECK_RESULT $? 0 0 "getfattr -n execute error"
    res2=$(getfattr -n user.test_getfattr test_getfattr.txt)
    echo "$res2" | grep -q 'user.test_getfattr="test_getfattr"' 
    CHECK_RESULT $? 0 0 "getfattr -n query error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_getfattr.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"

