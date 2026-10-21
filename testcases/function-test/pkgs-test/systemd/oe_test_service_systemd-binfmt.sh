#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test systemd-binfmt.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    found=0
    for d in /lib/binfmt.d /usr/lib/binfmt.d /usr/local/lib/binfmt.d /etc/binfmt.d /run/binfmt.d; do
        if [[ -d "$d" ]] && [[ -n "$(ls -A "$d" 2>/dev/null)" ]]; then
            found=1
            break
        else
            found=0
        fi
    done
    systemctl start systemd-binfmt.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "systemd-binfmt.service is an early boot service that registers additional binary formats for executables in the kernel"
    if (( found )); then
        test_oneshot systemd-binfmt.service 'active (exited)'
    else
        test_oneshot systemd-binfmt.service 'inactive (dead)'
    fi
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop systemd-binfmt.service
    LOG_INFO "End to restore the test environment."
}
main "$@"
