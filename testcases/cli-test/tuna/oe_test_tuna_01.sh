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
    LOG_INFO "Start to run test."
    tuna -h | grep "tuna"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    tuna -a example.conf
    CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
    tuna -l | grep -e "example.conf"
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    tuna -g &
    sleep 1
    kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: -g No Pass"
    tuna -G -t kthreadd -P | grep kthreadd
    CHECK_RESULT $? 0 0 "L$LINENO: -G No Pass"
    tuna -c 0,1 -t sshd -m -P | grep sshd
    tuna -c 0,1 -t sshd -m -P | grep "0, 1"
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    tuna -C -t systemd\* -P | grep "systemd"
    CHECK_RESULT $? 0 0 "L$LINENO: -C No Pass"
    tuna -f -t sshd -c 0 -P | grep sshd
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    tuna -c 0 -i -P | grep "0"
    CHECK_RESULT $? 0 0 "L$LINENO: -i No Pass"
    tuna -c 1 -i -P \
        -c 0 -I -P | grep sshd
    CHECK_RESULT $? 0 0 "L$LINENO: -I No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf savefile result example.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
