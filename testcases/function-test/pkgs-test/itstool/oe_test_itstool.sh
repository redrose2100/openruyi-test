#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linian
# @Contact   :   1173417216@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   Test itstool
# #############################################
# shellcheck disable=SC1090

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "itstool"
    mkdir out
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    itstool common/translate.xml -o out/out-o.pot
    CHECK_RESULT $? 0 0 "itstool -o failed"
    grep 'content of value0' out/out-o.pot
    CHECK_RESULT $? 0 0 "Failed to generate out/out-o.pot"
    itstool common/translate.xml --output=out/out--out.pot
    CHECK_RESULT $? 0 0 "itstool --output failed"
    grep 'content of value0' out/out--out.pot
    CHECK_RESULT $? 0 0 "Failed to generate out/out--out.pot"
    itstool -j common/IT-join-1.xml common/IT-join-1-cs.mo common/IT-join-1-de.mo -o out/out-j.xml
    CHECK_RESULT $? 0 0 "itstool -j failed"
    grep 'Diese Nachricht' out/out-j.xml
    CHECK_RESULT $? 0 0 "Failed to generate out/out-j.xml"
    itstool --join=common/IT-join-1.xml common/IT-join-1-cs.mo common/IT-join-1-de.mo -o out/out-j.xml
    CHECK_RESULT $? 0 0 "itstool --join failed"
    grep 'Diese Nachricht' out/out-j.xml
    CHECK_RESULT $? 0 0 "Failed to generate out/out-j.xml"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf out
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"