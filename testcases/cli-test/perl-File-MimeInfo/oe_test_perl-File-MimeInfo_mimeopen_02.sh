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
# @Author    :   huangdaorong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/01
# @License   :   Mulan PSL v2
# @Desc      :   Test perl-File-Mimeinfo
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "perl-File-MimeInfo tar"
    tar -zxvf common/test.tar.gz
    mkdir -p tmp/ /root/.local/share/applications/
    expect <<EOF 
    spawn mimeopen data/data.txt
    expect "use application" {send "1\n"}
    expect "use command" {send "vi\n"}
    expect "1" {send ":q\n"}
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF >tmp/1.txt
    spawn mimeopen --debug data/data.txt 
    expect "use application" {send "1\n"}
    expect "use command" {send "vi\n"}
    expect "1" {send ":q\n"}
EOF
    grep 'Checking' tmp/1.txt
    CHECK_RESULT $? 0 0 "Check mimeopen --debug failed"
    mimeopen --help | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Check mimeopen --help failed"
    mimeopen -h | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Check mimeopen -h failed"
    mimeopen --usage | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Check mimeopen --usage failed"
    mimeopen -u | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Check mimeopen -u failed"
    mimeopen --version | grep 'mimeopen .*'
    CHECK_RESULT $? 0 0 "Check mimeopen --version failed"
    mimeopen -v | grep 'mimeopen .*'
    CHECK_RESULT $? 0 0 "Check mimeopen -v failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp/ /root/.local/share/applications/ data/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
