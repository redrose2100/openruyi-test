#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-11
# @License   :   Mulan PSL v2
# @Desc      :   Use libsndfile case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libsndfile libsndfile-devel libsndfile-utils libsndfile-utils-help"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sndfile-info  common/test.wav | grep 'Length'
    CHECK_RESULT $? 0 0 "Error, The test.wav file does not exist"
    sndfile-convert common/test.wav common/test.flac
    CHECK_RESULT $? 0 0 "Error, Please reinstall libsndfile"
    test -e common/test.flac
    CHECK_RESULT $? 0 0 "Error, Please run sndfile again"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm common/test.flac
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
