#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test sassc
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sassc tar"
    tar -zxvf common/test.tar.gz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sassc -h | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: -h"
    sassc --version | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: version"
    cat test/tmp.css | sassc --stdin | grep 'width: auto; }'
    CHECK_RESULT $? 0 0 "Failed option: --stdin"
    cat test/tmp.css | sassc --style compressed | grep 'body{width:auto}'
    CHECK_RESULT $? 0 0 "Failed option: style"
    cat test/tmp.css | sassc --line-numbers | grep '\/\* line'
    CHECK_RESULT $? 0 0 "Failed option: line-numbers"
    cat test/tmp.css | sassc --load-path test/ | grep ' width: auto; }'
    CHECK_RESULT $? 0 0 "Failed option: load-path"
    cat test/tmp.css | sassc --plugin-path test/ | grep ' width: auto; }'
    CHECK_RESULT $? 0 0 "Failed option: plugin-path"
    cat test/tmp.css | sassc --sourcemap=inline | grep ' sourceMappingURL'
    CHECK_RESULT $? 0 0 "Failed option: sourcemap"
    cat test/tmp.css | sassc --precision 1 | grep ' 32.4 px'
    CHECK_RESULT $? 0 0 "Failed option: precision"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test/
    LOG_INFO "End to restore the test environment."
}

main "$@"
