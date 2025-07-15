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
# @Desc      :   verify the uasge of nvml command
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! yum list nvml &>/dev/null; then
         echo "skip unsupported arm arch"
         exit 255
    fi
    DNF_INSTALL nvml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pmempool create blk 512 pool.blk
    CHECK_RESULT $? 0 0 "Check pmempool create failed"
    pmempool info pool.blk 2>&1 | grep 'Part'
    CHECK_RESULT $? 0 0 "Check pmempool info failed"
    nohup pmempool dump pool.blk >blk.out &
    SLEEP_WAIT 3
    test -f ./blk.out
    CHECK_RESULT $? 0 0 "Check pmempool -f failed"
    pmempool check pool.blk
    CHECK_RESULT $? 0 0 "Check pmempool check failed"
    pmempool -V | grep "$(rpm -q nvml --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check pmempool -V failed"
    pmempool --version | grep "$(rpm -q nvml --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check pmempool --version failed"
    pmempool -h 2>&1 | grep 'usage: pmempool'
    CHECK_RESULT $? 0 0 "Check pmempool -h failed"
    pmempool --help 2>&1 | grep 'pmempool'
    CHECK_RESULT $? 0 0 "Check pmempool --help failed"
    pmempool rm pool.blk
    CHECK_RESULT $? 0 0 "Check pmempool rm failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf pool.* blk.*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
