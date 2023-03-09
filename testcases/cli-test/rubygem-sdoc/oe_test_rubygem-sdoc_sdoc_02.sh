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
    sdoc -r 2>&1 | grep "Generating RI format into"
    CHECK_RESULT $? 0 0 "Check sdoc -r failed"
    sdoc --ri 2>&1 | grep "Generating RI format into"
    CHECK_RESULT $? 0 0 "Check sdoc --ri failed"
    sdoc -R 2>&1 | grep "Generating RI format into /usr/share/ri/site"
    CHECK_RESULT $? 0 0 "Check sdoc -R failed"
    sdoc --ri-site 2>&1 | grep "Generating RI format into /usr/share/ri/site"
    CHECK_RESULT $? 0 0 "Check sdoc --ri-site failed"
    sdoc --webcvs='testdemocsv'
    CHECK_RESULT $? 0 0 "Check sdoc --webcvs failed"
    sdoc -W='testdemocsv'
    CHECK_RESULT $? 0 0 "Check sdoc -W failed"
    sdoc --copy-files="../common/hello.rb"
    CHECK_RESULT $? 0 0 "Check sdoc --copy-files failed"
    sdoc -t="testdemo" && grep "testdemo" doc/index.html
    CHECK_RESULT $? 0 0 "Check sdoc -t failed"
    sdoc --title="testdemo" && grep "testdemo" doc/index.html
    CHECK_RESULT $? 0 0 "Check sdoc --title failed"
    sdoc --template-stylesheets=../common/testdemo.css
    CHECK_RESULT $? 0 0 "Check sdoc --template-stylesheets failed"
    sdoc -T rails
    CHECK_RESULT $? 0 0 "Check sdoc -T failed"
    sdoc --template=rails
    CHECK_RESULT $? 0 0 "Check sdoc --template failed"
    sdoc -H
    CHECK_RESULT $? 0 0 "Check sdoc -H failed"
    sdoc --show-hash
    CHECK_RESULT $? 0 0 "Check sdoc --show-hash failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./mergedata/ ./common/*.rb ./common/*.sh ./common/testdemo.css
    LOG_INFO "End to restore the test environment."
}

main "$@"
