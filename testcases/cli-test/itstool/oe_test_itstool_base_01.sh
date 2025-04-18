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

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "itstool docbook-dtds"
    mkdir out
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    itstool --help | grep -Pz "Usage:\s\s  itstool"
    CHECK_RESULT $? 0 0 "itstool --help failed"
    itstool -h | grep -Pz "Usage:\s\s  itstool"
    CHECK_RESULT $? 0 0 "itstool -h failed"
    itstool -i common/import.its common/translate.xml | grep 'content of value1'
    CHECK_RESULT $? 0 0 "itstool -i failed"
    itstool --its common/import.its common/translate.xml | grep 'content of value1'
    CHECK_RESULT $? 0 0 "itstool --its failed"
    itstool -m common/translate.mo -o out/ common/translate.xml && grep 'result of value0' out/translate.xml
    CHECK_RESULT $? 0 0 "itstool -m failed"
    itstool --merge=common/translate.mo -o out/ common/translate.xml && grep 'result of value0' out/translate.xml
    CHECK_RESULT $? 0 0 "itstool --merge failed"
    itstool -l 'lang1' -m common/translate.mo -o out/ common/translate.xml && grep 'lang1' out/translate.xml
    CHECK_RESULT $? 0 0 "itstool -l failed"
    itstool --lang='lang1' -m common/translate.mo -o out/ common/translate.xml && grep 'lang1' out/translate.xml
    CHECK_RESULT $? 0 0 "itstool --lang failed"
    itstool -n common/translate.xml | grep 'content of value0'
    CHECK_RESULT $? 0 0 "itstool -n failed"
    itstool --no-builtins common/translate.xml | grep 'content of value0'
    CHECK_RESULT $? 0 0 "itstool --nobuitins failed"
    itstool --path=common/IT-externalRef1.txt common/IT-externalRef1.xml | grep 'ref'
    CHECK_RESULT $? 0 0 "itstool --path failed"
    itstool -s common/broken.xml | grep 'error'
    CHECK_RESULT $? 1 0 "itstool -s failed"
    itstool --strict common/broken.xml | grep 'error'
    CHECK_RESULT $? 1 0 "itstool --strct failed"
    itstool -d common/dtd.xml | grep 'translator'
    CHECK_RESULT $? 0 0 "itstool -d failed"
    itstool --load-dtd common/dtd.xml | grep 'translator'
    CHECK_RESULT $? 0 0 "itstool --load-dtd failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf out
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
