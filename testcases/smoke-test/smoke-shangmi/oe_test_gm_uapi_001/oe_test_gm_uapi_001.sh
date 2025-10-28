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
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/10/23
# @Desc      :   linux sm userspace api test
# ##################################
# shellcheck disable=SC2002,SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    rmmod sm4-generic
    DNF_INSTALL "gcc openssl-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    cat /proc/crypto | grep sm2 -A6
    CHECK_RESULT $? 0 0 "sm2 algorithm is not supported"

    cat /proc/crypto | grep sm3 -A8
    CHECK_RESULT $? 0 0 "sm3 algorithm is not supported"

    cat /proc/crypto | grep sm4 -A8
    CHECK_RESULT $? 1 0 "sm4 algorithm is supported before loading sm4-generic module"

    modprobe sm4-generic
    CHECK_RESULT $? 0 0 "Failed to load sm4-generic module"
    cat /proc/crypto | grep sm4 -A8
    CHECK_RESULT $? 0 0 "sm4 algorithm is not supported after loading sm4-generic module"

    gcc -o uapi_sm4 test_uapi_sm4.c
    CHECK_RESULT $? 0 0 "Failed to compile uapi_sm4 program"
    ./uapi_sm4  | grep -v '6532bc3a3762edf492b3d59412cdd7b2|Hello SM4'
    CHECK_RESULT $? 0 0 "sm4 uapi test failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rmmod sm4-generic
    rm ./uapi_sm4
    LOG_INFO "End to restore the test environment."
}

main "$@"


