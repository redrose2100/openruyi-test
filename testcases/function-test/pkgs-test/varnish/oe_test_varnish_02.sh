#!/usr/bin/bash

# Copyright (c) 2024. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangxiaoya
# @Contact   :   1426570981@qq.com
# @Date      :   2024/03/19
# @License   :   Mulan PSL v2
# @Desc      :   varnish common prepare
# #############################################
# shellcheck disable=SC1091
source "common/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    common_pre
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.list\\r"
            }
        }
        expect eof
EOF
    grep -iE "Backend" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.list failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.list -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "backend" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.list -g failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.list -p\\r"
            }
        }
        expect eof
EOF
    grep -iE "Backend name" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.list -p failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.list -a\\r"
            }
        }
        expect eof
EOF
    grep -iE "106" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.list -a prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.set_health default sick\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm backend.set_health default sick failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.set_health default healthy\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm backend.set_health default healthy failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.set_health default auto\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm backend.set_health default auto failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.set_health auto\\r"
            }
        }
        expect eof
EOF
    grep -iE "104" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.set_health auto prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.set_health server1 sick\\r"
            }
        }
        expect eof
EOF
    grep -iE "No Backends matches" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.set_health server1 sick prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "backend.set_health default a\\r"
            }
        }
        expect eof
EOF
    grep -iE "Invalid state a" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm backend.set_health default a prompt info error"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
