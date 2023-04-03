#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #######################################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test rc4 encryption and decryption file
# #######################################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openssl
    mkdir /tmp/test
    cd /tmp/test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    openssl genrsa -out 1.key 1024
    test -e 1.key
    CHECK_RESULT $? 0 0 "Generation failure 1"
    expect <<-END
    spawn openssl enc -e -rc4 -in 1.key -out 1.key.enc
    expect "password"
    send "123456\\n"
    expect "password"
    send "123456\\n"
    expect eof
    exit
END
    test -e 1.key.enc
    CHECK_RESULT $? 0 0 "Generation failure 2"
    expect <<-END
    spawn openssl enc -d -rc4 -in 1.key.enc -out 1.key.dec
    expect "password"
    send "123456\\n"
    expect eof
    exit
END
    test -e 1.key.dec
    CHECK_RESULT $? 0 0 "Generation failure 3"
    diff 1.key 1.key.dec
    CHECK_RESULT $? 0 0 "decryption failure"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /tmp/test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
