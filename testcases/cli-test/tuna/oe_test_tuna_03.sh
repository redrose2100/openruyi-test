#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   gaoyue
# @Contact   :   2829807379@qq.com
# @Date      :   2022/8/05
# @License   :   Mulan PSL v2
# @Desc      :   Test "tuna" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "tuna"
    systemctl restart sshd.service
    touch savefile
    cp /etc/tuna/example.conf ./
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_tuna."
    tuna -t sshd\* -P
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    tuna -U -t sshd -P
    CHECK_RESULT $? 0 0 "L$LINENO: -U No Pass"
    tuna -v | grep -E "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    tuna -t kthreadd -W | grep "kthread_create()"
    CHECK_RESULT $? 0 0 "L$LINENO: -W No Pass"
    tuna -t sshd -c 0,1 -x
    CHECK_RESULT $? 0 0 "L$LINENO: -x No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf savefile result example.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
