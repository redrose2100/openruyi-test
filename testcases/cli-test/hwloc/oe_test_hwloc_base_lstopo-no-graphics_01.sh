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
# @Date      :   2022/08/23
# @License   :   Mulan PSL v2
# @Desc      :   Test lstopo-no-graphics
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hwloc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lstopo-no-graphics -l | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -l failed"
    lstopo-no-graphics -l common/test_fn.console && cat common/test_fn.console | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -l failed"
    lstopo-no-graphics -p | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -p failed"
    lstopo-no-graphics -l --of console | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --of failed"
    lstopo-no-graphics -l common/test_fn.console -f && cat common/test_fn.console | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -f failed"
    lstopo-no-graphics -l --only PU | grep "PU"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -only <type> failed"
    lstopo-no-graphics -l -v | grep "local"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -v failed"
    lstopo-no-graphics -l -s | grep "depth"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -s failed"
    lstopo-no-graphics -l -c | grep "cpuset"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -c failed"
    lstopo-no-graphics -l -C | grep "0x"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -C failed"
    lstopo-no-graphics -l --taskset | grep "cpuset"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --taskset failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f common/test_fn.console
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"