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
                send "param.set -j ban_dups off\\r"
            }
        }
        expect eof
EOF
    grep -iE "false" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j ban_dups off failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j ban_dups on\\r"
            }
        }
        expect eof
EOF
    grep -iE "true" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j ban_dups on failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j ban_dups other\\r"
            }
        }
        expect eof
EOF
    grep -iE "on|off" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j ban_dups on prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j workspace_thread 2k\\r"
            }
        }
        expect eof
EOF
    grep -iE "workspace_thread" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread 2k failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j workspace_thread 0\\r"
            }
        }
        expect eof
EOF
    grep -iE "Must be at least 0.25k" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread 0 promot info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j workspace_thread 10m\\r"
            }
        }
        expect eof
EOF
    grep -iE "Must be no more than 8k" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread 10m promot info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j workspace_thread a\\r"
            }
        }
        expect eof
EOF
    grep -iE "Invalid number" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread a promot info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j pool_req 10,100,10\\r"
            }
        }
        expect eof
EOF
    grep -iE "max_pool" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req 10,100,10 failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j pool_req 10 100\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too many parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req 10 100 promot info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j pool_req 10\\r"
            }
        }
        expect eof
EOF
    grep -iE "Three fields required: min_pool, max_pool and max_age" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req 10 promot info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.set -j pool_req\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too few parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req promot info error"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
