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
    lstopo -l --input "node:2 2" | grep "NUMANode"
    CHECK_RESULT $? 0 0 "lstopo --input 'node:2 2' failed"
    lstopo -l --no-bridges | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --no-bridges failed"
    lstopo -l --whole-io | grep "Package"
    CHECK_RESULT $? 0 0 "lstopo --whole-io failed"
    lstopo -l common/test_fn.xml -f
    lstopo -l -i common/test_fn.xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo -i <XML file> failed"
    lstopo -l -i / | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo -i <directory> failed"
    lstopo -l -i "node:2 2" | grep "NUMANode"
    CHECK_RESULT $? 0 0 "lstopo -i 'node:2 2' failed"
    lstopo -l -i common/test_fn.xml --if xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --if <format> failed"
    lstopo -l --thissystem | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --thissystem failed"
    lstopo -l --pid 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --pid <pid> failed"
    lstopo -l --whole-system | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --whole-system failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f common/test_fn.xml
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"