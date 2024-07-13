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
    lstopo -l common/test_fn.xml -f
    lstopo -l --input common/test_fn.xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --input-format <type> failed"
    lstopo -l --export-synthetic-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --export-synthetic-flags failed"
    lstopo -l --ps | grep 'Package'
    CHECK_RESULT $? 0 0 "lstopo -l --ps failed"
    lstopo -l --top | grep 'Machine'
    CHECK_RESULT $? 0 0 "lstopo -l --top failed"
    lstopo -l --version | grep "lstopo [[:digit:]]"
    CHECK_RESULT $? 0 0 "lstopo -l --version failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f common/test_fn.xml
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
