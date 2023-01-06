source ${OET_PATH}/libs/locallibs/common_lib.sh
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
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mpich command
# ############################################

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL gperf
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gperf --enum ./common/test.gperf 2>&1 | grep 'Command-line: gperf --enum'
    CHECK_RESULT $? 0 0 "Check gperf --enum failed."
    gperf -I ./common/test.gperf 2>&1 | grep 'Command-line: gperf -I'
    CHECK_RESULT $? 0 0 "Check gperf -I failed."
    gperf --includes ./common/test.gperf 2>&1 | grep 'Command-line: gperf --includes'
    CHECK_RESULT $? 0 0 "Check gperf --includes failed."
    gperf -G ./common/test.gperf 2>&1 | grep 'Command-line: gperf -G'
    CHECK_RESULT $? 0 0 "Check gperf -G failed."
    gperf --global-table ./common/test.gperf 2>&1 | grep 'Command-line: gperf --global-table'
    CHECK_RESULT $? 0 0 "Check gperf --global-table failed."
    gperf -P ./common/test.gperf 2>&1 | grep 'Command-line: gperf -P'
    CHECK_RESULT $? 0 0 "Check gperf -P failed."
    gperf --pic ./common/test.gperf 2>&1 | grep 'Command-line: gperf --pic'
    CHECK_RESULT $? 0 0 "Check gperf --pic failed."
    gperf -Q 'NAME' ./common/test.gperf 2>&1 | grep 'Command-line: gperf -Q'
    CHECK_RESULT $? 0 0 "Check gperf -Q failed."
    gperf --string-pool-name='NAME' ./common/test.gperf 2>&1 | grep 'Command-line: gperf --string-pool-name'
    CHECK_RESULT $? 0 0 "Check gperf --string-pool-name failed."
    gperf --constants-prefix='PREFIX' ./common/test.gperf 2>&1 | grep 'Command-line: gperf --constants-prefix'
    CHECK_RESULT $? 0 0 "Check gperf --constants-prefix failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "Finish restore the test environment."
}

main $@
