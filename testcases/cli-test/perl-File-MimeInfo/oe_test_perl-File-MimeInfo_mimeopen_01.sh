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
    spawn mimeopen -a data/data.txt 
    expect "use application" {send "1\n"}
    expect "use command" {send "vi\n"}
    expect "1" {send ":q\n"}
EOF
    grep ' with vi' tmp/1.txt
    CHECK_RESULT $? 0 0 "Check mimeopen -a failed"
    expect <<EOF >tmp/2.txt
    spawn mimeopen --ask data/data.txt 
    expect "use application" {send "1\n"}
    expect "use command" {send "vi\n"}
    expect "1" {send ":q\n"}
EOF
    grep ' with vi' tmp/2.txt
    CHECK_RESULT $? 0 0 "Check mimeopen --ask failed"
    expect <<EOF >tmp/3.txt
    spawn mimeopen -d data/data.txt 
    expect "use application" {send "1\n"}
    expect "1" {send ":q\n"}
EOF
    grep 'use application' tmp/3.txt
    CHECK_RESULT $? 0 0 "Check mimeopen -d failed"
    expect <<EOF >tmp/4.txt
    spawn mimeopen --ask-default data/data.txt 
    expect "use application" {send "1\n"}
    expect "1" {send ":q\n"}
EOF
    grep 'use application' tmp/4.txt
    CHECK_RESULT $? 0 0 "Check mimeopen --ask-default failed"
    expect <<EOF >tmp/5.txt
    spawn mimeopen -n data/data.txt 
    expect "1" {send ":q\n"}
EOF
    grep 'data/data.txt' tmp/5.txt
    CHECK_RESULT $? 0 0 "Check mimeopen -n failed"
    expect <<EOF >tmp/6.txt
    spawn mimeopen --no-ask data/data.txt 
    expect "1" {send ":q\n"}
EOF
    grep 'data/data.txt' tmp/6.txt
    CHECK_RESULT $? 0 0 "Check mimeopen --no-ask failed"
    expect <<EOF >tmp/7.txt
    spawn mimeopen -M data/data.txt 
    expect "1" {send ":q\n"}
EOF
    grep 'data/data.txt' tmp/7.txt
    CHECK_RESULT $? 0 0 "Check mimeopen -M failed"
    expect <<EOF >tmp/8.txt
    spawn mimeopen --magic-only data/data.txt 
    expect "1" {send ":q\n"}
EOF
    grep 'data/data.txt' tmp/8.txt
    CHECK_RESULT $? 0 0 "Check mimeopen --magic-only failed"
    expect <<EOF >tmp/9.txt
    spawn mimeopen --database=/usr/share/mime data/data.txt 
    expect "1" {send ":q\n"}
EOF
    grep 'data/data.txt' tmp/9.txt
    CHECK_RESULT $? 0 0 "Check mimeopen --database failed"
    expect <<EOF >tmp/10.txt
    spawn mimeopen -D data/data.txt 
    expect "1" {send ":q\n"}
EOF
    grep 'data/data.txt' tmp/10.txt
    CHECK_RESULT $? 0 0 "Check mimeopen -D failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp/ /root/.local/share/applications/ data/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
