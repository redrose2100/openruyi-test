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
    DNF_INSTALL "itstool"
    if ! rpm -qa itstool | grep "2.0.4"; then
        exit 255
    fi
    mkdir out
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    itstool common/translate.xml >out/out-o.pot && grep 'content of value0' out/out-o.pot
    CHECK_RESULT $? 0 0 "itstool > failed"
    itstool -j common/IT-join-1.xml common/IT-join-1-cs.mo common/IT-join-1-de.mo >out/out-j.xml && grep 'Diese Nachricht' out/out-j.xml
    CHECK_RESULT $? 0 0 "itstool -j failed"
    itstool --join=common/IT-join-1.xml common/IT-join-1-cs.mo common/IT-join-1-de.mo >out/out-j.xml && grep 'Diese Nachricht' out/out-j.xml
    CHECK_RESULT $? 0 0 "itstool --join failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf out
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
