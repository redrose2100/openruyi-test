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
    DNF_INSTALL rubygem-sdoc
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pushd data
    sdoc -g "https://github.com/strictdoc-project/strictdoc.git"
    CHECK_RESULT $? 0 0 "Check sdoc -g failed"
    rm -rf doc
    sdoc --github "https://github.com/strictdoc-project/strictdoc.git"
    CHECK_RESULT $? 0 0 "Check sdoc --github failed"
    rm -rf doc
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./mergedata/
    LOG_INFO "End to restore the test environment."
}

main "$@"
