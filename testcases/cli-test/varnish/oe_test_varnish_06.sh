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
                send "pid\\r"
            }
        }
        expect eof
EOF
    grep -iE "Master" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm pid ailed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "pid -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "master" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm pid -j failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "pid -a\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too many parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "pid -a prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "status -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "status" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm status -j failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "storage.list\\r"
            }
        }
        expect eof
EOF
    grep -iE "storage" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm storage.list failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "storage.list -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "name" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm storage.list -j failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "storage.list -a\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too many parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "storage.list -a prompt info error"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "vcl.deps\\r"
            }
        }
        expect eof
EOF
    grep -iE "boot" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "vcl.deps failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "vcl.deps -j\\r"
            }
        }
        expect eof
EOF
    grep -iE "boot" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm vcl.deps -j failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "vcl.deps -a\\r"
            }
        }
        expect eof
EOF
    grep -iE "Too many parameters" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "vcl.deps -a prompt info error"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
