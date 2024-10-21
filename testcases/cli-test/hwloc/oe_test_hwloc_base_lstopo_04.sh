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
# @Desc      :   Test lstopo
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hwloc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lstopo --logical | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --logical failed"
    lstopo --logical common/test_fn.console && cat common/test_fn.console
    CHECK_RESULT $? 0 0 "lstopo --logical failed" 
    lstopo --physical | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --physical failed"
    lstopo -l --output-format xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --output-format failed"
    touch common/test_fn.xml
    lstopo -l common/test_fn.xml --force && grep "Machine" common/test_fn.xml
    CHECK_RESULT $? 0 0 "lstopo --force failed"
    lstopo -l --verbose | grep "local"
    CHECK_RESULT $? 0 0 "lstopo --verbose failed"
    lstopo -l --silent | grep "depth"
    CHECK_RESULT $? 0 0 "lstopo --silent failed"
    lstopo -l --cpuset | grep "cpuset"
    CHECK_RESULT $? 0 0 "lstopo --cpuset failed"
    lstopo -l --cpuset-only | grep "0x"
    CHECK_RESULT $? 0 0 "lstopo --cpuset-only failed"
    lstopo -l --input common/test_fn.xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --input <type> failed"
    lstopo -l --input / | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo -l --input <directory> failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f common/test_fn.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"