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
    cp data/cpanm /usr/bin/cpanm 
    chmod +x /usr/bin/cpanm
    cpanm IO::Scalar
    mkdir -p /root/.local/share/applications/
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
    mimetype --noalign data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --noalign failed"
    mimetype --output-format %f data/data.txt | grep 'data/data.txt'
    CHECK_RESULT $? 0 0 "Check mimetype --output-format failed"
    echo '1111' | mimetype --stdin | grep 'text/plain'
    CHECK_RESULT $? 0 0 "Check mimetype --stdin failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /root/.local/share/applications/ data/ /usr/bin/cpanm /usr/local/share/perl5/IO
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
