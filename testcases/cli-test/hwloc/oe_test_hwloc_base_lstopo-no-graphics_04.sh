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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hwloc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lstopo-no-graphics --logical | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --logical failed"
    lstopo-no-graphics --logical common/test_fn.console && cat common/test_fn.console
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --logical failed" 
    lstopo-no-graphics --physical | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --physical failed"
    lstopo-no-graphics -l --output-format xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --output-format failed"
    touch common/test_fn.xml
    lstopo-no-graphics -l common/test_fn.xml --force && grep "Machine" common/test_fn.xml
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --force failed"
    lstopo-no-graphics -l --verbose | grep "local"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --verbose failed"
    lstopo-no-graphics -l --silent | grep "depth"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --silent failed"
    lstopo-no-graphics -l --cpuset | grep "cpuset"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --cpuset failed"
    lstopo-no-graphics -l --cpuset-only | grep "0x"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --cpuset-only failed"
    lstopo-no-graphics -l --input common/test_fn.xml | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --input <type> failed"
    lstopo-no-graphics -l --input / | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -l --input <directory> failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f common/test_fn.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"