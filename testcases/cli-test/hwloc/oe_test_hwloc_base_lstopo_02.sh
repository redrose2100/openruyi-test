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
# @Author    :   zhangshaowei
# @Contact   :   756800989@qq.com
# @Date      :   2022/08/24
# @License   :   Mulan PSL v2
# @Desc      :   Test lstopo
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hwloc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lstopo -l --ignore PU | grep -v " PU"
    CHECK_RESULT $? 0 0 "lstopo --ignore <type> failed"
    lstopo -l --no-caches | grep -v "L2 L#0"
    CHECK_RESULT $? 0 0 "lstopo --no-caches failed"
    lstopo -l --no-useless-caches | grep -v "L2 L#0"
    CHECK_RESULT $? 0 0 "lstopo --no-useless-caches failed"
    lstopo -l --no-icaches | grep -v "L1i L#0"
    CHECK_RESULT $? 0 0 "lstopo --no-icaches failed"
    lstopo -l --merge | grep -v "Package"
    CHECK_RESULT $? 0 0 "lstopo --merge failed"
    lstopo -l --no-collapse | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --no-collapse failed"
    lstopo -l --restrict 1 | grep "L#0"
    CHECK_RESULT $? 0 0 "lstopo --restrict <cpuset> failed"
    lstopo -l --restrict binding | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --restrict binding failed"
    lstopo -l --restrict-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --restrict-flags <n> failed"
    lstopo -l --no-io | grep -v "HostBridge"
    CHECK_RESULT $? 0 0 "lstopo --no-io failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
