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
    gperf --ignore-case ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --ignore-case failed."
    gperf -L 'C' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -L failed."
    gperf --language='C' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --language failed."
    gperf -t -K "NAME" ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -t -K  failed."
    gperf -t --initializer-suffix=1 ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -t --initializer-suffix failed."
    gperf -t -F "1" ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -F failed."
    gperf -H 'HASH' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -H failed."
    gperf --hash-function-name='HASH' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --hash-function-name failed."
    gperf -N 'NAME' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -N failed."
    gperf -Z 'NAME' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -Z failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
