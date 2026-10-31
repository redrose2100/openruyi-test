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
# @Desc      :   Two modes of SCP
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# /etc/openEuler-latest 只在 openEuler 系镜像存在，衍生发行版回退到标准的 /etc/os-release。
OS_INFO_FILE=/etc/openEuler-latest
[ -f "${OS_INFO_FILE}" ] || OS_INFO_FILE=/etc/os-release
# 校验传输内容的特征串，避免硬编码发行版名称。
OS_INFO_PATTERN='openeulerversion=|^ID='

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF
        spawn scp ${NODE2_USER}@${NODE2_IPV4}:${OS_INFO_FILE} /tmp/openEuler-latest
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    CHECK_RESULT $?
    grep -qE "${OS_INFO_PATTERN}" /tmp/openEuler-latest
    CHECK_RESULT $?
    expect <<EOF
        spawn scp ${OS_INFO_FILE} ${NODE2_USER}@${NODE2_IPV4}:/tmp/openEuler-latest
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    CHECK_RESULT $?
    SSH_CMD "grep -qE '${OS_INFO_PATTERN}' /tmp/openEuler-latest" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/openEuler-latest
    SSH_CMD "rm -rf /tmp/openEuler-latest" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to restore the test environment."
}

main "$@"
