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
                send "param.set -j ban_dups on\\r"
            }
        }
        expect {
            "*varnish*" {
                send "param.set -j workspace_thread 3k\\r"
            }
        }
        expect {
            "*varnish*" {
                send "param.show\\r"
            }
        }
        expect eof
EOF

    grep -iE "default" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -l\\r"
            }
        }
        expect eof
EOF
    grep -iE "workspace_session" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -l failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "workspace_thread" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -j failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -j changed\\r"
            }
        }
        expect eof
EOF
    grep -iE "workspace_thread" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -j changed failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -l changed\\r"
            }
        }
        expect eof
EOF
    grep -iE "Minimum" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -l changed failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show changed\\r"
            }
        }
        expect eof
EOF
    grep -iE "workspace_thread" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show changed failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -l workspace_thread\\r"
            }
        }
        expect eof
EOF
    grep -iE "Maximum" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -l workspace_thread failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -l vsl_space changed\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too many parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -l vsl_space changed prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show -l aaa\\r"
            }
        }
        expect eof
EOF
    grep -iE "Unknown parameter" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -l aaa prompt info error"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
