#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of perl-libwww-perl command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL perl-libwww-perl
    LOG_INFO "Start to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lwp-dump --agent 'str' http://www.baidu.com 2>&1 | grep 'Vary:'
    CHECK_RESULT $? 0 0 "Check lwp-dump --agent failed"
    lwp-dump --keep-client-headers http://www.baidu.com 2>&1 | grep 'Client-'
    CHECK_RESULT $? 0 0 "Check lwp-dump --keep-client-headers failed"
    lwp-dump --max-length 10 http://www.baidu.com 2>&1 | grep 'Bdpagetype:'
    CHECK_RESULT $? 0 0 "Check lwp-dump --max-length failed"
    lwp-dump --method 'GET' http://www.baidu.com 2>&1 | grep 'Server:'
    CHECK_RESULT $? 0 0 "Check lwp-dump --method failed"
    lwp-dump --parse-head http://www.baidu.com 2>&1 | grep 'head'
    CHECK_RESULT $? 0 0 "Check lwp-dump --parse-head  failed"
    lwp-dump --request http://www.baidu.com 2>&1 | grep 'P3p'
    CHECK_RESULT $? 0 0 "Check lwp-dump --request failed"
    lwp-download -a http://www.baidu.com ./ 2>&1 | grep 'Saving'
    CHECK_RESULT $? 0 0 "Check lwp-download -a  failed"
    lwp-download -s http://www.baidu.com ./index.html
    CHECK_RESULT "$(test -f ./index.html)"
    lwp-mirror -v 2>&1 | grep 'This is lwp-mirror version'
    CHECK_RESULT $? 0 0 "Check lwp-mirror -v failed"
    lwp-mirror -t 10 http://www.baidu.com a.txt
    CHECK_RESULT $? 0 0 "Check lwp-mirror -t failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf a.txt index.*
    DNF_REMOVE
    LOG_INFO "End to restoring the test environment."
}

main $@
