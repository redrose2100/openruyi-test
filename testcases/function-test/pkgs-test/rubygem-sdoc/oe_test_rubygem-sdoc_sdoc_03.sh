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
    sdoc -N
    CHECK_RESULT $? 0 0 "Check sdoc -N failed"
    sdoc --line-numbers
    CHECK_RESULT $? 0 0 "Check sdoc --line-numbers failed"
    sdoc --no-line-numbers
    CHECK_RESULT $? 0 0 "Check sdoc --no-line-numbers failed"
    sdoc --main=README.rdoc
    CHECK_RESULT $? 0 0 "Check sdoc --main failed"
    sdoc -m README.rdoc
    CHECK_RESULT $? 0 0 "Check sdoc -m failed"
    sdoc --hyperlink-all
    CHECK_RESULT $? 0 0 "Check sdoc --hyperlink-all failed"
    sdoc -A
    CHECK_RESULT $? 0 0 "Check sdoc -A failed"
    sdoc --charset=UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc --charset failed"
    sdoc -c UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc -c failed"
    sdoc -d
    CHECK_RESULT $? 0 0 "Check sdoc -d failed"
    sdoc -o tmpdir1 && test -d tmpdir1
    CHECK_RESULT $? 0 0 "Check sdoc -o failed"
    sdoc --output tmpdir2 && test -d tmpdir2
    CHECK_RESULT $? 0 0 "Check sdoc --output failed"
    sdoc --op=tmpd && test -d tmpd
    CHECK_RESULT $? 0 0 "Check sdoc --op failed"
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
