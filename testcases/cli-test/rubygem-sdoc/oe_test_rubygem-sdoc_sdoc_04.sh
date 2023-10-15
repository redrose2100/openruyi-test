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
    sdoc -C
    CHECK_RESULT $? 0 0 "Check sdoc -C failed"
    sdoc --coverage-report
    CHECK_RESULT $? 0 0 "Check sdoc --coverage-report failed"
    sdoc --no-coverage-report
    CHECK_RESULT $? 0 0 "Check sdoc --no-coverage-report failed"
    sdoc --dcov
    CHECK_RESULT $? 0 0 "Check sdoc --dcov failed"
    sdoc --no-dcov
    CHECK_RESULT $? 0 0 "Check sdoc --no-dcov failed"
    sdoc -i ./common
    CHECK_RESULT $? 0 0 "Check sdoc -i failed"
    sdoc --include=../common
    CHECK_RESULT $? 0 0 "Check sdoc --include failed"
    sdoc -f sdoc
    CHECK_RESULT $? 0 0 "Check sdoc -f failed"
    sdoc --fmt sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --fmt failed"
    sdoc --format=sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --format failed"
    sdoc -O
    CHECK_RESULT $? 0 0 "Check sdoc -O failed"
    sdoc --force-output
    CHECK_RESULT $? 0 0 "Check sdoc --force-output failed"
    sdoc --page-dir=./common
    CHECK_RESULT $? 0 0 "Check sdoc --page-dir failed"
    rootdir=$(pwd)
    sdoc --root=${rootdir}
    CHECK_RESULT $? 0 0 "Check sdoc --root failed"
    sdoc --markup=tomdoc
    CHECK_RESULT $? 0 0 "Check sdoc --markup failed"
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
