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
#@Desc          :   bash setfattr formatted test
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "This is a test for setfattr" > test_setfattr.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    setfattr -n user.test_setfattr -v "test_setfattr" test_setfattr.txt
    CHECK_RESULT $? 0 0 "setfattr -n execute error"
    res1=$(getfattr -d test_setfattr.txt)
    grep -q 'user.test_setfattr="test_setfattr"' $res1
    getfattr -d test_setfattr.txt | grep 'user.test_setfattr'
    CHECK_RESULT $? 0 0 "setfattr setting error"
    setfattr -x user.test_setfattr test_setfattr.txt
    CHECK_RESULT $? 0 0 "setfattr -n execute error"
    res2=$(getfattr -d test_setfattr.txt | grep 'user.test_setfattr')
    [ -z "$res2" ]
    CHECK_RESULT $? 0 0 "setfattr clean error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_setfattr.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"

