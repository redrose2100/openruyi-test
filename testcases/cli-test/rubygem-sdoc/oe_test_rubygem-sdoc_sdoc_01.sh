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
    sdoc -h | grep "Usage: sdoc"
    CHECK_RESULT $? 0 0 "Check sdoc -h failed"
    sdoc --help | grep "Usage: sdoc"
    CHECK_RESULT $? 0 0 "Check sdoc --help failed"
    sdoc -v | grep "sdoc $(rpm -q rubygem-sdoc | awk -F '-' '{print $3}')"
    CHECK_RESULT $? 0 0 "Check sdoc -v failed"
    sdoc --version | grep "sdoc $(rpm -q rubygem-sdoc | awk -F '-' '{print $3}')"
    CHECK_RESULT $? 0 0 "Check sdoc --version failed"
    sdoc -V | grep "template/rails/index.rhtml"
    CHECK_RESULT $? 0 0 "Check sdoc -V failed"
    sdoc --verbose | grep "template/rails/index.rhtml"
    CHECK_RESULT $? 0 0 "Check sdoc --verbose failed"
    sdoc -q && test -d doc
    CHECK_RESULT $? 0 0 "Check sdoc -q failed"
    sdoc --quiet && test -d doc
    CHECK_RESULT $? 0 0 "Check sdoc --quiet failed"
    sdoc --dwasda --ignore-invalid 2>&1 | grep "invalid options: --dwasda"
    CHECK_RESULT $? 0 0 "Check sdoc --ignore-invalid failed"
    sdoc --no-ignore-invalid --asdawd
    CHECK_RESULT $? 1 0 "Check sdoc --ignore-invalid failed"
    sdoc -D | grep "install -c -p -m 644"
    CHECK_RESULT $? 0 0 "Check sdoc -D failed"
    sdoc --debug | grep "install -c -p -m 644"
    CHECK_RESULT $? 0 0 "Check sdoc --debug failed"
    sdoc --no-debug | grep "Constants:"
    CHECK_RESULT $? 0 0 "Check sdoc --no-debug failed"
    sdoc --dry-run 2>&1 | grep "Generating SDoc format into"
    CHECK_RESULT $? 1 0 "Check sdoc --dry-run failed"
    sdoc --no-dry-run 2>&1 | grep "Generating SDoc format into"
    CHECK_RESULT $? 0 0 "Check sdoc --no-dry-run failed"
    sdoc --markup rdoc --write-options && grep "markup: rdoc" .rdoc_options
    CHECK_RESULT $? 0 0 "Check sdoc --write-options failed"
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
