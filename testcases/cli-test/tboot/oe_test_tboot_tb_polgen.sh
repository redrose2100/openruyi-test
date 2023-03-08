#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of tboot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tboot
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    tb_polgen --create --alg sha1 --type continue common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
    tb_polgen --create --alg sha1 --type nonfatal common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
    tb_polgen --create --alg sha1 --type halt common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
    tb_polgen --create --type nonfatal --alg sha1 --ctrl 0x00 --verbose common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
    tb_polgen --add --num 0 --pcr 19 --hash image --cmdline "$(cut -d' ' -f2- </proc/cmdline)" --image "/boot/vmlinuz-$(uname -r)" common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash --cmdline --image failed"
    tb_polgen --add --num 1 --pcr 20 --hash image --image "/boot/initramfs-$(uname -r).img" common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash --image failed"
    tb_polgen --add --num 1 --pcr 20 --hash image --image "/boot/initramfs-$(uname -r).img" --verbose common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash --image --verbose failed"
    tb_polgen --del --num 0 common/vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --del --num failed"
    tb_polgen --show common/vl.pol 2>&1 | grep 'policy:'
    CHECK_RESULT $? 0 0 "Check tb_polgen --show failed"
    tb_polgen --help 2>&1 | grep 'tb_polgen --create --type'
    CHECK_RESULT $? 0 0 "Check tb_polgen --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
