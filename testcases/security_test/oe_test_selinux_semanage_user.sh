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
# @Date      :   2023-7-20
# @License   :   Mulan PSL v2
# @Desc      :   selinux semanage user manage
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libselinux policycoreutils-python-utils"
    # 对selinux是否被禁用进行判断
    setenforce 1  #如果在内核层禁用了selinux,那么这里是无法打开的
    if [ "$(getenforce)" == "Disabled" ]; then
        LOG_WARN "Testing cannot be performed if selinux cannot be enabled."
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    semanage user -l
    CHECK_RESULT $? 0 0 "check selinux user info fail"
    semanage user -a -L s0 -r "s0-s0:c0.c1023" -R sysadm_r test
    semanage user -l | grep test | awk '{print $5}' | grep sysadm_r
    CHECK_RESULT $? 0 0 "add selinux user member fail"
    semanage user -m -R user_r test
    semanage user -l | grep test | awk '{print $5}' | grep user_r
    CHECK_RESULT $? 0 0 "modifing selinux user role fail"
    semanage user -d  test
    semanage user -l | grep test
    CHECK_RESULT $? 0 1 "delete selinux user member fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
