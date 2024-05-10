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
    varnishadm -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "varnish -h failed"
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "quit\\r"
            }
        }
        expect eof
EOF
    grep -iE "help|quit" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm quit failed"
    grep -iE "Closing" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm quit failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "help\\r"
            }
        }
        expect eof
EOF
    grep -iE "response" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm help failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "help -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "Authenticate" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm help failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "help -j ban\\r"
            }
        }
        expect eof
EOF
    grep -iE "ban" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm help failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "help -j ban -z\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too many parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm help failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "status\\r"
            }
        }
        expect eof
EOF
    grep -iE "Child in state running" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm status failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "stop\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm stop failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "start\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm start failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "ban.list\\r"
            }
        }
        expect eof
EOF
    grep -iE "Present bans" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm ban.list failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "ban.list -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "completed" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm ban.list failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "banner\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm banner failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file  /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "ban\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too few parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm ban prompt info error"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
