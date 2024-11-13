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
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test bregex
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    if yum list | grep -q "mysql5-server"; then
        DNF_INSTALL "bacula-client mysql5-server bacula-common tar"
    else
        DNF_INSTALL "bacula-client mysql-server bacula-common tar"
    fi
    tar -zxvf common/test.tar.gz
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF >tmp/1.txt
    exp_internal 1
    set timeout -1
    spawn bregex -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    grep 'Director' tmp/1.txt
    CHECK_RESULT $? 0 0 "test bregex -f failed"
    expect <<EOF >tmp/2.txt
    exp_internal 1
    set timeout -1
    spawn bregex -d 33 -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    grep '.* Director' tmp/2.txt
    CHECK_RESULT $? 0 0 "test bregex -d failed"
    expect <<EOF >tmp/3.txt
    exp_internal 1
    set timeout -1
    spawn bregex -l -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    grep -v '.* Director' tmp/3.txt
    CHECK_RESULT $? 0 0 "test bregex -l failed"
    expect <<EOF >tmp/4.txt
    exp_internal 1
    set timeout -1
    spawn bregex -n -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    grep 'Enter regex pattern: Director' tmp/4.txt
    CHECK_RESULT $? 0 0 "test bregex -n failed"
    expect <<EOF >tmp/5.txt
    exp_internal 1
    set timeout -1
    spawn bregex -dt -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    grep 'Director' tmp/5.txt
    CHECK_RESULT $? 0 0 "test bregex -dt failed"
    bregex -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bregex -? failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    DNF_REMOVE
    rm -rf config/ tmp/
    LOG_INFO "End to restore the test environment."
}

main "$@"
