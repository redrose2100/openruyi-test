#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test sassc
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "sassc tar"
    tar -zxvf common/test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat test/tmp.css | sassc -a  | grep 'width: auto; }'
    CHECK_RESULT $? 0 0 "Failed option: -a"
    cat test/tmp.css | sassc --line-comments | grep '\/\* line'
    CHECK_RESULT $? 0 0 "Failed option: line-numbers"
    cat test/tmp.css | sassc -M | grep 'font-size: 32.44 px; }'
    CHECK_RESULT $? 0 0 "Failed option: -M"
    cat test/tmp.css | sassc --sass  | grep 'width: auto; }'
    CHECK_RESULT $? 0 0 "Failed option: sass"
    cat test/tmp.css | sassc --omit-map-comment | grep 'font-size: 32.44 px; }'
    CHECK_RESULT $? 0 0 "Failed option: omit-map-comment"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
