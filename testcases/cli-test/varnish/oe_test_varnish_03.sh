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
                send "panic.clear -z\\r"
            }
        }
        expect eof
EOF
    grep -icE "200" /tmp/log_varnishadm | grep 2
    CHECK_RESULT $? 0 0 "varnishadm panic.clear -z failed"

    rm -rf /tmp/log_varnishadm
    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.show\\r"
            }
        }
        expect eof
EOF
    grep -iE "accept" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show failed"

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
    grep -iE "implemented" /tmp/log_varnishadm
    CHECK_RESULT $? 0 0 "varnishadm param.show -j failed"

    rm -rf /tmp/log_varnishadm

    shuf -n 3 <common/param >random_param

    random_value1=$(awk '{print $1}' <random_param | xargs | awk '{print $1}')
    random_value2=$(awk '{print $1}' <random_param | xargs | awk '{print $2}')
    random_value3=$(awk '{print $1}' <random_param | xargs | awk '{print $3}')

    expect <<EOF
        log_file /tmp/log_varnishadm
        spawn varnishadm
        expect {
            "*varnish*" {
                send "param.reset $random_value1\\r"
            }
        }
        expect {
            "*varnish*" {
                send "param.reset $random_value2\\r"
            }
        }
        expect {
            "*varnish*" {
                send "param.reset $random_value3\\r"
            }
        }
        expect eof
EOF
    line_count=$(grep -iEc "200" /tmp/log_varnishadm)
    if [[ "$line_count" -ge 3 ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "varnishadm param.reset failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf random_param
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
