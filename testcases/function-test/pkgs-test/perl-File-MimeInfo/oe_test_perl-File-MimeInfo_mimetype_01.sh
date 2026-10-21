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
    expect <<EOF > tmp/1.txt
    spawn mimeopen data/data.txt
    expect "use application" {send "1\n"}
    expect "use command" {send "vi\n"}
    expect "*" {send ":q\n"}
    expect eof
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mimetype -a data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -a failed"
    mimetype --all data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --all failed"
    mimetype -b data/data.txt | grep 'text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype -b failed"
    mimetype --brief data/data.txt | grep 'text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --brief failed"
    mimetype --database=/usr/share/mime data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --database failed"
    mimetype --file-compat -d data/data.txt | grep 'plain text document\|Plain text document'
    CHECK_RESULT $? 0 0 "Check mimetype -d failed"
    mimetype --file-compat --describe data/data.txt | grep 'plain text document\|Plain text document'
    CHECK_RESULT $? 0 0 "Check mimetype --describ failed"
    mimetype -D data/data.txt | grep 'text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --D failed"
    mimetype  --debug data/data.txt | grep 'text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --debug failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp/ /root/.local/share/applications/ data/
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
