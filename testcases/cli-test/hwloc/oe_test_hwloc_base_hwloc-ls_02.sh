#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    :   zhangshaowei
# @Contact   :   756800989@qq.com
# @Date      :   2022/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test hwloc-ls
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start testing..."
    hwloc-ls --taskset | grep "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --taskset failed"
    hwloc-ls --ignore pu | grep -v "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --ignore   failed"
    hwloc-ls --no-caches  | grep " HostBridge"
    CHECK_RESULT $? 0 0 "hwloc-ls --no-caches  failed"
    hwloc-ls --no-useless-caches | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --no-useless-caches  failed"
    hwloc-ls --no-collapse | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --no-collapse  failed"
    hwloc-ls --no-icaches | grep " HostBridge"
    CHECK_RESULT $? 0 0 "hwloc-ls --no-icaches  failed"
    hwloc-ls --merge | grep "HostBridge"
    CHECK_RESULT $? 0 0 "hwloc-ls --merge  failed"
    hwloc-ls --restrict 0x00000001 | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --restrict  failed"
    hwloc-ls --restrict binding | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --restrict binding  failed"
    hwloc-ls --restrict-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --restrict-flags  failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
