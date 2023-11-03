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
    expect eof
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mimetype --version | grep 'mimetype .*'
    CHECK_RESULT $? 0 0 "Check mimetype --version failed"
    mimetype -i data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -i failed"
    mimetype --mimetype data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --mimetype failed"
    mimetype -L data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -L failed"
    mimetype --dereference data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --dereference failed"
    mimetype -l en data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -l failed"
    mimetype --language=en data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --language failed"
    mimetype -M en data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -M failed"
    mimetype --magic-only data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --agic-only failed"
    mimetype -N data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -N failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp/ /root/.local/share/applications/ data/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
