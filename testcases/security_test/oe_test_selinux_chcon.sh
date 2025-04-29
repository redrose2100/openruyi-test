#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-6-28
# @License   :   Mulan PSL v2
# @Desc      :   selinux chcon
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test
    su - test -c "touch /home/test/testfile"
    echo 123 > /home/test/testfile
    DNF_INSTALL "libselinux"
    status01="$(getenforce)"
    # 对selinux是否被禁用进行判断
    setenforce Enforcing  #如果在内核层禁用了selinux,那么这里是无法打开的
    if [ "$(getenforce)" == "Disabled" ]; then
        LOG_WARN "Testing cannot be performed if selinux cannot be enabled."
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "start to run test."
    chcon -t root_t /home/test/testfile
    CHECK_RESULT $? 0 0 "setting selinux context type fail"
    chcon -u user_u /home/test/testfile
    CHECK_RESULT $? 0 0 "setting selinux context user fail"
    setenforce 0
    CHECK_RESULT $? 0 0 "setting selinux mode fail"
    chcon -r user_r /home/test/testfile
    CHECK_RESULT $? 0 0 "setting selinux context role fail"
    biaoqian01="$(ls -Z /home/test/testfile)"
    echo  "${biaoqian01}" |  grep "user_u:user_r:root_t"
    CHECK_RESULT $? 0 0 "selinux context is error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    setenforce "${status01}"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
