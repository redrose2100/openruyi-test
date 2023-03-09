#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test sdoc
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh 

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-sdoc tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pushd data
    sdoc --visibility=private
    CHECK_RESULT $? 0 0 "Check sdoc --visibility failed"
    sdoc -w 10
    CHECK_RESULT $? 0 0 "Check sdoc -w failed"
    sdoc --tab-width=15
    CHECK_RESULT $? 0 0 "Check sdoc --tab-width failed"
    sdoc -U
    CHECK_RESULT $? 0 0 "Check sdoc -U failed"
    sdoc --no-force-update
    CHECK_RESULT $? 0 0 "Check sdoc --no-force-update failed"
    sdoc -E cgi=rb
    CHECK_RESULT $? 0 0 "Check sdoc -E failed"
    sdoc --extension cgi=rb
    CHECK_RESULT $? 0 0 "Check sdoc --extension failed"
    sdoc -x sdoc | grep "Files:      18"
    CHECK_RESULT $? 0 0 "Check sdoc -x failed"
    sdoc --exclude=sdoc | grep "Files:      18"
    CHECK_RESULT $? 0 0 "Check sdoc --exclude failed"
    sdoc -a
    CHECK_RESULT $? 0 0 "Check sdoc -a failed"
    sdoc --all
    CHECK_RESULT $? 0 0 "Check sdoc --all failed"
    sdoc --locale-data-dir=sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --locale-data-dir failed"
    sdoc --locale=sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --locale failed"
    sdoc -e UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc -e failed"
    sdoc --encoding UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc --encoding failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./mergedata/ ./common/*.rb ./common/*.sh
    LOG_INFO "End to restore the test environment."
}

main "$@"
