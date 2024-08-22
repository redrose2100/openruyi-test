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
# @Desc      :   Test bwild
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-client mysql-server bacula-common tar"
    tar -zxvf common/test.tar.gz
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bwild -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bwild -? failed"
    expect <<EOF > tmp/1.txt
    spawn bwild -f /etc/bacula/bacula-sd.conf 
    expect "Enter a wild-card:" {send "*\n"}
    expect "Enter a wild-card:" {send "\n"}
EOF
    grep 'Device' tmp/1.txt
    CHECK_RESULT $? 0 0 "test bwild -f failed"
    expect <<EOF > tmp/2.txt
    spawn bwild -f /etc/bacula/bacula-sd.conf 
    expect "Enter a wild-card:" {send "*\n"}
    expect "Enter a wild-card:" {send "\n"}
EOF
    grep 'Device' tmp/2.txt
    CHECK_RESULT $? 0 0 "test bwild -l failed"
    expect <<EOF > tmp/3.txt
    spawn bwild -n -f /etc/bacula/bacula-sd.conf 
    expect "Enter a wild-card:" {send "1\n"}
    expect "Enter a wild-card:" {send "\n"}
EOF
    grep 'Device' tmp/3.txt
    CHECK_RESULT $? 0 0 "test bwild -n failed"
    expect <<EOF > tmp/4.txt
    spawn bwild -i -f /etc/bacula/bacula-sd.conf 
    expect "Enter a wild-card:" {send "1\n"}
    expect "Enter a wild-card:" {send "\n"}
EOF
    grep -v 'Device' tmp/4.txt
    CHECK_RESULT $? 0 0 "test bwild -i failed"
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
