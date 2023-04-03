#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test curvetun
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # test -v
    curvetun -v | grep "curvetun"
    CHECK_RESULT $? 0 0 "Check curvetun -v failed"
    # test --version
    curvetun --version | grep "curvetun"
    CHECK_RESULT $? 0 0 "Check curvetun --version failed"
    # test -h
    curvetun -h | grep "Usage: curvetun"
    CHECK_RESULT $? 0 0 "Check curvetun -h failed"
    # test --help
    curvetun -h | grep "Usage: curvetun"
    CHECK_RESULT $? 0 0 "Check curvetun -h failed"
    # test -k
    expect << EOF
        spawn curvetun -k
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    test -f ~/.curvetun/pub.key
    CHECK_RESULT $? 0 0 "Check curvetun -k failed"
    rm -f ~/.curvetun/*
    # test --keygen
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    test -f ~/.curvetun/pub.key
    CHECK_RESULT $? 0 0 "Check curvetun --keygen failed"
    rm -f ~/.curvetun/*
    # test -x
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    curvetun -x | grep "Your exported public information"
    CHECK_RESULT $? 0 0 "Check curvetun -x failed"
    rm -f ~/.curvetun/*
    # test --export
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    curvetun --export | grep "Your exported public information"
    CHECK_RESULT $? 0 0 "Check curvetun --export failed"
    rm -f ~/.curvetun/*
    # test -C
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    echo "tunserver;89:56:84:0f:62:59:38:55:2b:c9:7f:93:c2:24:19:1f:49:e4:ea:d2:61:2b:b2:73:b0:2a:eb:7b:42:f0:0d:1d" > ~/.curvetun/clients
    curvetun -C | grep "tunserver -> 89:56"
    CHECK_RESULT $? 0 0 "Check curvetun -C failed"
    rm -f ~/.curvetun/*
    # test --dumpc
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    echo "tunserver;89:56:84:0f:62:59:38:55:2b:c9:7f:93:c2:24:19:1f:49:e4:ea:d2:61:2b:b2:73:b0:2a:eb:7b:42:f0:0d:1d" > ~/.curvetun/clients
    curvetun --dumpc | grep "tunserver -> 89:56"
    CHECK_RESULT $? 0 0 "Check curvetun --dumpc failed"
    rm -f ~/.curvetun/*
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
