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
# @Desc      :   Test lstopo-no-graphics
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hwloc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lstopo-no-graphics -l --input "node:2 2" | grep "NUMANode"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --input 'node:2 2' failed"
    lstopo-no-graphics -l --no-bridges | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-bridges failed"
    lstopo-no-graphics -l --whole-io | grep "Package"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --whole-io failed"
    lstopo-no-graphics -l common/test_fn.xml -f
    lstopo-no-graphics -l -i common/test_fn.xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -i <XML file> failed"
    lstopo-no-graphics -l -i / | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -i <directory> failed"
    lstopo-no-graphics -l -i "node:2 2" | grep "NUMANode"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -i 'node:2 2' failed"
    lstopo-no-graphics -l -i common/test_fn.xml --if xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --if <format> failed"
    lstopo-no-graphics -l --thissystem | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --thissystem failed"
    lstopo-no-graphics -l --pid 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --pid <pid> failed"
    lstopo-no-graphics -l --whole-system | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --whole-system failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f common/test_fn.xml
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
