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
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test bregex
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "bacula-client mysql5-server bacula-common"
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    expect <<EOF > /tmp/1.txt
    spawn bregex -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    cat /tmp/1.txt | grep 'Director'
    CHECK_RESULT $? 0 0 "Failed option: -f"
    expect <<EOF > /tmp/2.txt
    spawn bregex -d 33 -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    cat /tmp/2.txt | grep '.* Director'
    CHECK_RESULT $? 0 0 "Failed option: -d"
    expect <<EOF > /tmp/3.txt
    spawn bregex -l -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    cat /tmp/3.txt | grep -v '.* Director'
    CHECK_RESULT $? 0 0 "Failed option: -l"
    expect <<EOF > /tmp/3.txt
    spawn bregex -n -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    cat /tmp/3.txt | grep '.*'
    CHECK_RESULT $? 0 0 "Failed option: -n"
    expect <<EOF > /tmp/4.txt
    spawn bregex -dt -f ./config/a.config
    expect "Enter regex pattern: " {send "Director\n"}
    expect "Enter regex pattern:" {send "\n"}
EOF
    cat /tmp/4.txt | grep 'Director'
    CHECK_RESULT $? 0 0 "Failed option: -dt"
    bregex -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: -?"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf config/ /tmp/*.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
