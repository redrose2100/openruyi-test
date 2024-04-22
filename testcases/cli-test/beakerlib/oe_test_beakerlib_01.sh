#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   hourui
# @Contact   :   867559702@qq.com
# @Date      :   2022/8/05
# @License   :   Mulan PSL v2
# @Desc      :   Test "beakerlib" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python beakerlib"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bash ./common/test.sh
    CHECK_RESULT $? 0 0 "beakerlib package may be broken!"
    beakerlib-rlMemAvg ps
    CHECK_RESULT $? 0 0 "beakerlib-rlMemAvg failed!"
    beakerlib-rlMemPeak ps
    CHECK_RESULT $? 0 0 "beakerlib-rlMemPeak failed!"
    beakerlib-testwatcher ps
    CHECK_RESULT $? 0 0 "beakerlib-testwatcher failed!"
    beakerlib-journalling -m ./common/journal.meta -j ./common/journal_new.txt
    CHECK_RESULT $? 0 0 "beakerlib-journalling failed!"
    beakerlib-journalling -m ./common/journal.meta -j ./common/journal.xml -x ./common/xunit.xslt
    CHECK_RESULT $? 0 0 "beakerlib-journalling -x failed!"
    beakerlib-journalcmp ./common/journal.txt ./common/journal_new.txt
    CHECK_RESULT $? 0 0 "beakerlib-journalcmp failed!"
    beakerlib-deja-summarize ./common/test.sum
    CHECK_RESULT $? 0 0 "beakerlib-deja-summarize failed!"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f ./common/journal_new.txt ./common/journal.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
